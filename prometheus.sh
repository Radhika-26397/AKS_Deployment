#!/bin/bash

# Define public Kubernetes chart repository in the Helm configuration
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update local repositories
helm repo update

# Search for newly installed repositories
helm repo list

# Create a namespace for Prometheus and Grafana resources
kubectl create ns prometheus

# Install Prometheus using HELM
helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus

# Check all resources in Prometheus Namespace
kubectl get all -n prometheus

# Port forward the Prometheus service
kubectl port-forward -n prometheus prometheus-prometheus-kube-prometheus-prometheus-0 9090

# Get the Username
kubectl get secret -n prometheus prometheus-grafana -o=jsonpath='{.data.admin-user}' |base64 -d

# Get the Password
kubectl get secret -n prometheus prometheus-grafana -o=jsonpath='{.data.admin-password}' |base64 -d

# Port forward the Grafana service
kubectl port-forward -n prometheus prometheus-grafana-5449b6ccc9-b4dv4 3000

# Create SPN and assign Monitoring Reader Role on the AKS Cluster ResourceGroup
az ad sp create-for-rbac --role="Monitoring Reader" --scopes="/subscriptions/4ed68a4b-d54d-444a-bddb-fdfec0f1b130/resourceGroups/rg-aks-deployment-centralindia-01"