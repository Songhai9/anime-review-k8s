#!/usr/bin/env bash

set -euo pipefail

: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD must be set}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

./install_addons.sh

kubectl create secret generic postgres-secrets \
  --namespace anime-review \
  --from-literal=POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f storage/gp3-storageclass.yaml
kubectl apply -f storage/postgresql-statefulset.yaml
kubectl apply -f storage/postgres-service.yaml

kubectl rollout status statefulset/postgres --timeout=180s

kubectl apply -f backend/
kubectl rollout status deployment/backend-deployment --timeout=180s

kubectl apply -f frontend/
kubectl rollout status deployment/frontend-deployment --timeout=180s

kubectl apply -f ingress/