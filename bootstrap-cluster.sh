#!/usr/bin/env bash

set -euo pipefail

export KUBECONFIG="${KUBECONFIG:-/etc/kubernetes/admin.conf}"
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

POSTGRES_PASSWORD="$(
  aws ssm get-parameter \
    --name "/anime-review/postgres/password" \
    --with-decryption \
    --query 'Parameter.Value' \
    --output text \
    --region eu-north-1
)"

if [[ -z "$POSTGRES_PASSWORD" ]]; then
  echo "Unable to retrieve PostgreSQL password"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Installing cluster add-ons"
./install_addons.sh

echo "==> Creating application namespace"
kubectl apply -f namespace/anime-review.yaml

echo "==> Configuring PostgreSQL secret"
kubectl create secret generic postgres-secrets \
  --namespace anime-review \
  --from-literal=POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  --dry-run=client \
  -o yaml \
  | kubectl apply -f -

echo "==> Configuring cluster storage"
kubectl apply -f storage/gp3-storageclass.yaml

echo "==> Deploying Anime Review Helm release"
helm upgrade --install anime-review \
  ./charts/anime-review \
  --namespace anime-review \
  --server-side=true \
  --wait \
  --atomic \
  --timeout 5m

echo "==> Helm release status"
helm status anime-review \
  --namespace anime-review

echo "==> Application bootstrap completed successfully"