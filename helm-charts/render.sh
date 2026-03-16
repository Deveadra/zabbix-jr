#!/bin/sh -e

# Specify the NGINX Helm chart version to use
HELM_CHART_VERSION=7.0.12

# Define key directory paths relative to the git repository root
GIT_ROOT="$(git rev-parse --show-toplevel)"
CHARTS_DIR="$GIT_ROOT/helm-charts/charts"     # Where the chart will be untarred (raw chart files)
RENDERED_DIR="$GIT_ROOT/helm-charts/rendered" # Where Helm will output rendered Kubernetes manifests
DESTINATION_DIR="$GIT_ROOT/deployment/zabbix-jr"  # Where final manifests will be copied for deployment

# Clean up any previous chart, rendered, or destination directories to ensure a fresh start
rm -rf "$CHARTS_DIR" "$RENDERED_DIR" "$DESTINATION_DIR"
mkdir -p "$CHARTS_DIR" "$RENDERED_DIR" "$DESTINATION_DIR"

helm repo add zabbix-community https://zabbix-community.github.io/helm-zabbix

# Update local Helm repo cache to get the latest chart versions
helm repo update

helm pull \
    --untar \
    --untardir "$CHARTS_DIR" \
    --version "$HELM_CHART_VERSION" \
    zabbix-community/zabbix

# Render the Helm chart as plain Kubernetes YAML using your custom values
# This does not install anything to the cluster, just outputs manifests for review or GitOps
helm template \
    zabbix \
    --version "$HELM_CHART_VERSION" \
    --namespace "$(printf '%s' "$USER" | tr '[:upper:]' '[:lower:]')" \
    --dependency-update \
    --values "$GIT_ROOT/helm-charts/custom-values.yaml" \
    --output-dir "$RENDERED_DIR" \
    zabbix-community/zabbix

# Copy the rendered manifests to the deployment directory for easy kubectl apply
cp -R "$RENDERED_DIR/zabbix/templates/"* "$DESTINATION_DIR"
