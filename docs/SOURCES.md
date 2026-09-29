# Sources and scope

Revision checked on September 29, 2026: `ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b`.

The READMEs describe the code at this revision. GitLab settings, the AWS account and running resources were not audited or modified for this delivery. Examples are supplementary templates to fill in; historical CI copies are identified separately.

- [`.gitlab-ci.yml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/.gitlab-ci.yml)
- [`addons/aws-ebs-csi-driver/values.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/addons/aws-ebs-csi-driver/values.yaml)
- [`addons/ingress-nginx/values.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/addons/ingress-nginx/values.yaml)
- [`addons/metrics-server/values.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/addons/metrics-server/values.yaml)
- [`backend/backend-deployment.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/backend/backend-deployment.yaml)
- [`backend/backend-service.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/backend/backend-service.yaml)
- [`bootstrap-cluster.sh`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/bootstrap-cluster.sh)
- [`frontend/frontend-deployment.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/frontend/frontend-deployment.yaml)
- [`frontend/frontend-service.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/frontend/frontend-service.yaml)
- [`ingress/ingress.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/ingress/ingress.yaml)
- [`install_addons.sh`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/install_addons.sh)
- [`namespace/anime-review.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/namespace/anime-review.yaml)
- [`networking/backend.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/networking/backend.yaml)
- [`networking/database.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/networking/database.yaml)
- [`networking/default-deny-ingress.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/networking/default-deny-ingress.yaml)
- [`networking/frontend.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/networking/frontend.yaml)
- [`storage/gp3-storageclass.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/storage/gp3-storageclass.yaml)
- [`storage/postgres-service.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/storage/postgres-service.yaml)
- [`storage/postgresql-statefulset.yaml`](https://github.com/Songhai9/anime-review-k8s/blob/ea4c10677d3aa0a62e4731afa8895ca2f1d84d0b/storage/postgresql-statefulset.yaml)
