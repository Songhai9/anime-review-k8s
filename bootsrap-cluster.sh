#!/usr/bin/env bash

set -euo pipefail

./install_addons.sh
kubectl apply -f storage/gp3-storageclass.yaml
kubectl apply -f storage/postgresql-statefulset.yaml
kubectl apply -f storage/postgres-service.yaml
kubectl apply -f backend/
kubectl apply -f frontend/
kubectl apply -f ingress/