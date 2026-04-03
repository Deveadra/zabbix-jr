# AGENTS.md

This file guides coding agents working in this repository.
Treat it as a living document and update it whenever repository structure, CI
behavior, or deployment flow changes.

## Project Overview

- Repository: zabbix-jr
- Purpose: Kubernetes deployment assets for Zabbix JR.
- Primary deployment path: GitLab CI uses glue-k8s-deploy templates and deploys
files from deployment templates.
- Secondary/local helper path: Helm is used for initial rendering/reference, not
as the authoritative deployment mechanism in CI.

## Source of Truth

- CI pipeline behavior is defined in [.gitlab-ci.yml](.gitlab-ci.yml).
- Runtime deployment templates live in [deployment/zabbix-jr](deployment/zabbix-jr).
- Local rendering utilities live in [helm-charts/render.sh](helm-charts/render.sh)
 and [helm-charts/custom-values.yaml](helm-charts/custom-values.yaml).

When CI behavior conflicts with Helm-rendered output, prefer CI + deployment
templates as the source of truth.

## Preferred Agent Workflow

1. Read [.gitlab-ci.yml](.gitlab-ci.yml) first to understand environment
variables and deploy/delete jobs.
2. Inspect [deployment/zabbix-jr](deployment/zabbix-jr) before changing rollout
behavior.
3. Use [helm-charts/render.sh](helm-charts/render.sh) only when intentionally
re-baselining manifests from Helm.
4. Keep changes minimal and scoped to the user request.

## Do / Do Not

- Do preserve variable names used by glue-k8s-deploy (for example
`KAPP_NAMESPACE`, `HOST_NAME`, `KUBECFG_VAULT_PATH`, `STORAGE_CLASS`, `ZABBIX_IMAGE_TAG`).
- Do keep acceptance/union/deliver environment intent intact unless explicitly requested.
- Do update docs when behavior changes (at minimum [README.md](README.md),
[PROCESS.md](PROCESS.md), and this file).
- Do not silently switch deployment ownership back to Helm-generated manifests.
- Do not remove template files in [deployment/zabbix-jr](deployment/zabbix-jr)
unless replacing with an explicitly approved pattern.

## Local Commands

- Deploy with glue-k8s-deploy container:

```sh
docker compose -f docker-compose-gkd.yaml up
```

- Render/template only:

```sh
GLUE_CMD=template docker compose -f docker-compose-gkd.yaml up
```

- Delete deployed resources:

```sh
GLUE_CMD=delete docker compose -f docker-compose-gkd.yaml up
```

- Re-render Helm manifests intentionally:

```sh
./helm-charts/render.sh
```

## Validation Checklist For Changes

- Confirm modified variables still match CI expectations in [.gitlab-ci.yml](.gitlab-ci.yml).
- Confirm template filenames and paths under [deployment/zabbix-jr](deployment/zabbix-jr)
remain consistent.
- If deployment behavior changed, run at least template rendering locally and
review output.
- Ensure documentation is aligned with the current behavior.

## Maintenance Rules For This File

Update this file in the same MR whenever any of the following changes:

- Deployment flow (Helm vs glue-k8s-deploy responsibilities)
- CI job names, stages, or required variables
- Template locations or naming conventions
- Local developer commands in [docker-compose-gkd.yaml](docker-compose-gkd.yaml)
