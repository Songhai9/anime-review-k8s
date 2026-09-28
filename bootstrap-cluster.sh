#!/usr/bin/env bash

set -euo pipefail

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

./install_addons.sh

kubectl apply -f namespace/anime-review.yaml

kubectl create secret generic postgres-secrets \
  --namespace anime-review \
  --from-literal=POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f storage/gp3-storageclass.yaml
kubectl apply -f storage/postgresql-statefulset.yaml
kubectl apply -f storage/postgres-service.yaml

kubectl rollout status statefulset/postgres \
  -n anime-review \
  --timeout=180s


kubectl apply -f backend/
kubectl rollout status deployment/backend-deployment \
  -n anime-review \
  --timeout=180s

kubectl apply -f frontend/
kubectl rollout status deployment/frontend-deployment \
  -n anime-review \
  --timeout=180s

kubectl apply -f ingress/

kubectl apply -f networking/