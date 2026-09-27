#!/bin/bash

helm upgrade --install aws-ebs-csi-driver \
  oci://registry.k8s.io/provider-aws/charts/aws-ebs-csi-driver \
  --version 2.66.0 \
  --namespace kube-system \
  -f addons/aws-ebs-csi-driver/values.yaml \
  --wait \
  --timeout 5m