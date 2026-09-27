#!/usr/bin/env bash

set -euo pipefail

EBS_CSI_CHART_VERSION="2.66.0"
INGRESS_NGINX_CHART_VERSION="4.15.1"
METRICS_SERVER_CHART_VERSION="3.14.0"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "==> Checking prerequisites"

command -v kubectl >/dev/null 2>&1 || {
  echo "kubectl is required"
  exit 1
}

command -v helm >/dev/null 2>&1 || {
  echo "helm is required"
  exit 1
}

kubectl cluster-info >/dev/null

echo "==> Configuring Helm repositories"

helm repo add ingress-nginx \
  https://kubernetes.github.io/ingress-nginx \
  --force-update

helm repo update

echo "==> Installing AWS EBS CSI driver"

helm upgrade --install aws-ebs-csi-driver \
  oci://registry.k8s.io/provider-aws/charts/aws-ebs-csi-driver \
  --version "$EBS_CSI_CHART_VERSION" \
  --namespace kube-system \
  -f addons/aws-ebs-csi-driver/values.yaml \
  --wait \
  --timeout 5m

echo "==> Installing ingress-nginx"

helm upgrade --install ingress-nginx \
  ingress-nginx/ingress-nginx \
  --version "$INGRESS_NGINX_CHART_VERSION" \
  --namespace ingress-nginx \
  --create-namespace \
  -f addons/ingress-nginx/values.yaml \
  --wait \
  --timeout 5m

echo "==> Installing metrics-server"

helm repo add metrics-server \
  https://kubernetes-sigs.github.io/metrics-server/ \
  --force-update

helm repo update

helm upgrade --install metrics-server \
  metrics-server/metrics-server \
  --version "$METRICS_SERVER_CHART_VERSION" \
  --namespace kube-system \
  -f addons/metrics-server/values.yaml \
  --wait \
  --timeout 5m

  echo "==> Add-ons installed successfully"

helm list -n kube-system
helm list -n ingress-nginx