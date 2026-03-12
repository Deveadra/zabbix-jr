# Zabbix-JR Local Development Guide

## Overview
This guide covers only local development steps.

---

## Prerequisites

- Helm installed
- `kubectl` installed and pointed to your local/dev Kubernetes context

---

## Local Development Steps

### 1) Render manifests

```sh
chmod +x helm-charts/render.sh
helm-charts/render.sh
```

Expected result:

- Rendered manifests are generated in `helm-charts/rendered/zabbix/templates/`
- Deployable manifests are copied to `deployment/`

### 2) Apply resources

```sh
kubectl apply -f deployment
```

### 3) Verify workload

```sh
kubectl get pods -n [namespace]
kubectl get svc -n [namespace]
```

### 4) Port-forward Zabbix web service

```sh
kubectl port-forward service/zabbix-zabbix-web 8888:80 -n [namespace]
```

Open: http://localhost:8888

### 5) Delete resources

```sh
kubectl delete -f deployment
```

---

## Troubleshooting

- If resources are missing, re-run the render step before `kubectl apply`.
- If port-forward fails, verify the service exists: `kubectl get svc -n monitoring`.
