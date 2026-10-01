# Checks, incidents and operations

[Home](../README.md) · [Installation](../README.md)

Run these commands with an authorized `kubectl` context. On the control plane, use `export KUBECONFIG=/etc/kubernetes/admin.conf` with the necessary permissions. Do not publish this administrative kubeconfig.

## Basic diagnostics

```bash
kubectl get nodes -o wide
kubectl -n anime-review get pods -o wide
kubectl -n anime-review get events --sort-by=.lastTimestamp
kubectl -n anime-review logs deployment/backend-deployment --tail=100
kubectl -n anime-review logs deployment/frontend-deployment --tail=100
kubectl -n anime-review logs statefulset/postgres --tail=100
kubectl -n anime-review get deployment backend-deployment frontend-deployment \
  -o 'custom-columns=NAME:.metadata.name,IMAGES:.spec.template.spec.containers[*].image'
```

| Symptom | Concrete check | Appropriate response |
|---|---|---|
| `ImagePullBackOff` | `kubectl describe pod`, tag, ARM64 architecture, registry Secret and ServiceAccount | Publish the correct tag or repair credentials, then recreate pods |
| Backend not Ready | Logs, `/ready`, Secret, postgres Service and DB policy | Fix SQL connectivity before increasing replicas |
| Frontend 502/API error | `API_URL`, backend Service/endpoints and frontend→backend policy | Fix internal connectivity; do not expose the API publicly |
| PVC Pending | `describe pvc`, CSI pods, worker IAM, IMDS, AZ and scheduling | With WaitForFirstConsumer, also wait for a consumer node to be selected |
| EBS attachment failure | Volume/node AZ, previous attachment and events | Respect zone affinity and RWO usage |
| DB pod CrashLoop | SQL logs, mount, PGDATA and memory | Check the pgdata subdirectory and existing data |
| NLB failure | Target health, NodePorts, ingress-nginx pods and frontend Service | Trace from the external network down to the service |
| SSM `TargetNotConnected` | Exact ID, Online agent, IAM and outbound HTTPS | Fix SSM; kubectl may not have started yet |
| AWS waiter failure | `get-command-invocation` and actual status | Wait for/diagnose the current command before starting another deployment |
| Secret changed but SQL authentication fails | Compare the SQL role against the intended secret | Explicit SQL rotation, consistent Secret and client restarts |

## Available metrics

Once metrics-server works, use `kubectl top nodes` and `kubectl top pods -n anime-review`. Requests guide scheduling; limits constrain resource usage. No HPA is defined, so load does not automatically add replicas. Insecure kubelet TLS bypasses certificate verification; it does not repair certificates.

API liveness `/health` checks the process. Readiness `/ready` runs `SELECT 1`: pods that cannot reach the database are removed from ready endpoints. Frontend `/health` does not validate AniList and PostgreSQL end to end.

## Persistence and backups

PostgreSQL requests an 8 GiB gp3 RWO PVC with Retain. A retained PV is not automatically reassigned to a new cluster installation. EBS belongs to an AZ; moving the pod does not make its volume available in every zone. EC2 root volumes and Terraform state are separate resources.

The repository provides no automated backup strategy. For a manual logical backup, write a local file outside Git and inspect the result:

```bash
kubectl -n anime-review exec postgres-0 -- \
  pg_dump -U postgres_user -d postgres_db -Fc > anime-review-backup.dump
# Inspect using a compatible pg_restore, then test an isolated restoration.
pg_restore --list anime-review-backup.dump
```

Here, `pg_dump` runs inside the container using a local PostgreSQL connection. Depending on effective `pg_hba.conf`, additional authentication may be needed. Do not consider a backup validated until restoration is tested in a separate environment. The archive may contain personal data; keep it outside the repository with restricted access.

Do not delete the PVC/namespace to fix a simple application issue. Do not assume redeployment restores data. Updating `POSTGRES_PASSWORD` in a Secret does not modify the role of an already initialized database.

## Application rollback

The durable approach is to restore previous image references in Git through a new commit, then deploy. First inspect SQL schema compatibility: returning to an old image does not restore a modified database.

A controlled emergency `kubectl rollout undo` can revert a Deployment, but it does not update Git. Reconcile manifests afterward, otherwise a later pipeline can reintroduce the rejected version. No automated rollback pipeline is supplied.

## Features that should not be confused

- Two API replicas do not guarantee placement on two workers: these manifests have no API topology-spread constraint.
- The Ingress controller has its own spread constraint; that is not a property of every pod.
- An ingress NetworkPolicy does not deny pod egress.
- NLB TCP 443 does not itself provide a valid HTTPS certificate.
- A Git-versioned chart plus CI running `helm upgrade` is push-based delivery, not a continuously reconciling GitOps operator.
