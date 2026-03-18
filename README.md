# orbit-tenants

GitOps repo for Orbit per-tenant Helm values. **Managed by orbit-operator** — do not edit manually.

## Structure

```
orbit-tenants/
├── charts/
│   └── tenant-app/          # Helm chart for per-tenant stack (app, postgres, valkey, ingress, monitoring)
└── tenants/
    └── {slug}/
        └── values.yaml      # Per-tenant Helm values — committed by orbit-operator on provisioning
```

## How it works

1. User creates an `OrbitTenant` CR on the cluster
2. `orbit-operator` reconciles: creates namespace, RBAC, NetworkPolicy, ArgoCD AppProject
3. Operator commits `tenants/{slug}/values.yaml` to this repo (via GitHub PAT)
4. Operator creates an ArgoCD `Application` CR pointing to `tenants/{slug}/` in this repo
5. ArgoCD syncs the Helm chart with tenant-specific values → workloads deploy in `tenant-{slug}-prod`
6. Operator polls ArgoCD health until `Health=Healthy` → marks tenant `Active`

## Adding a tenant manually (for testing)

```bash
kubectl apply -f - <<EOF
apiVersion: platform.orbit.sh/v1alpha1
kind: OrbitTenant
metadata:
  name: e2e-test
spec:
  slug: e2e-test
  plan: starter
  owner:
    email: test@orbit.lustres.dev
  git:
    repoUrl: https://github.com/lustresconsulting/simple-http-server
    branch: main
EOF
```

## Chart values reference

See `charts/tenant-app/values.yaml` for all configurable values.
