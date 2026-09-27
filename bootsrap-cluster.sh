#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD must be set}"

./install_addons.sh

kubectl create secret generic postgres-secrets \
  --from-literal=POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
  --dry-run=client \
  -o yaml \
  | kubectl apply -f -

kubectl apply -f storage/gp3-storageclass.yaml
kubectl apply -f storage/postgresql-statefulset.yaml
kubectl apply -f storage/postgres-service.yaml
kubectl apply -f backend/
kubectl apply -f frontend/
kubectl apply -f ingress/