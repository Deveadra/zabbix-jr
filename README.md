# Zabbix-JR Local Development Guide

## Overview

This guide covers only local development steps.

---

## Prerequisites

- `kubectl` installed
- Namespace in `o11n-eks-o11n-dev` cluster

---

## 🛂 Access AWS and o11n-dev cluster

1. Get access to `jw-cd-lab-1` AWS account
   - See: [Access AWS with Granted](https://techdocs.bethelservice.org/how-to/access-aws-granted/)
1. Get `o11n-dev` cluster KubeConfig from Vault

   - Export the Vault address.

     ```bash
     export VAULT_ADDR="https://vault.o11n.jw-cd-gitlab.10aws.org"
     ```

   - Login to Vault.

     ```bash
     vault login -method=oidc skip_browser=true
     ```

     > ℹ️ Open link in a browser to authenticate with second account.

   - Export the Vault token.

     ```bash
     export VAULT_TOKEN=$(cat ~/.vault-token)
     ```

     > ❗️ You will need to authenticate again after around 15 minutes.
     Make sure you're using your second account.
1. Update your local *kubeconfig* for the `o11n-dev` cluster:

   ```bash
   aws eks update-kubeconfig --region us-east-1 --name o11n-eks-o11n-dev
   ```

   This command will allow you to use `kubectl` and `k9s` to view resources in the cluster.

## 🚀 Deploy Zabbix Jr

1. Deploy kubernetes deployment files coming from [deployment/zabbix-jr](https://git.bethelservice.org/ACAMERON/zabbix-jr/-/tree/main/deployment/zabbix-jr?ref_type=heads)

   ```bash
   docker compose -f docker-compose-gkd.yaml up
   ```

   > ℹ️ To create the deployment file without deploying it, run
   `GLUE_CMD=template docker compose -f docker-compose-gkd.yaml up`
1. Retrieve the `HOST_NAME` URL from `docker-compose-gkd.yaml`
and open the URL in the browser. The Zabbix Login
interface should appear.

    **Default Credentials**:
    - Username: Admin
    - Password: zabbix

## 🧹 Clean up deployment

1. Destroy k8s manifests:

   ```bash
   GLUE_CMD=delete docker compose -f docker-compose-gkd.yaml up
   ```

   > ℹ️ Make sure to do this before redeploying.
