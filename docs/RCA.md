# Incident Response and RCA

## Summary
After a deployment, the customer-facing backend service experienced routing issues during testing. The backend pods were running, but service availability became inconsistent due to service-level drift during troubleshooting.

## Detection
I detected the issue by checking Kubernetes resources and service health:
- `kubectl get pods`
- `kubectl get svc`
- `kubectl get endpoints backend`

The backend pods were running, but at one point the backend Service was missing, which would prevent stable service access.

## Severity and Impact
Severity was considered medium to high because the backend API is customer-facing and loss of service routing would cause failed requests from dependent components.

Potential customer impact:
- API traffic to backend could fail
- frontend-to-backend communication could be affected
- user-facing errors such as 502/504 could occur depending on gateway behavior

## Triage Process

### Application Layer
- Checked pod status using `kubectl get pods`
- Verified containers were running
- Reviewed deployment rendering through Helm:
  - `helm template backend ./helm/backend-chart`

### Kubernetes Layer
- Checked services:
  - `kubectl get svc`
- Checked endpoints:
  - `kubectl get endpoints backend`
- Confirmed whether the Service could correctly discover backend pods

### GitOps / Argo CD Layer
- Checked Argo CD applications:
  - `kubectl get applications -n argocd`
- Observed that Argo CD application sync state became `Unknown` during recovery testing

### Gateway / Traffic Layer
- Verified that service exposure depended on a healthy backend Service and valid endpoints
- Identified that missing or mismatched service routing would break traffic even if pods were healthy

## Root Cause
The root cause was service-level inconsistency introduced during troubleshooting and manifest testing. The backend pods were healthy, but the backend Service was not consistently present/reconciled, which interrupted stable traffic routing.

## Mitigation
To restore service quickly:
- Re-rendered the backend Helm chart
- Re-applied the rendered manifests directly:
  - `helm template backend ./helm/backend-chart | kubectl apply -f -`

This immediately recreated the missing backend Service and confirmed the backend deployment state.

## Recovery Validation
Recovery was confirmed by:
- `kubectl get svc backend`
- `kubectl get endpoints backend`
- `kubectl get pods -l app=backend`

Validation showed:
- backend Service recreated successfully
- endpoints populated with backend pod IPs
- backend pods healthy and running

## Follow-up Actions
- Add stronger GitOps validation checks before sync
- Add a pre-deployment validation step for Services and Endpoints
- Use safer test scenarios for injected failures
- Improve Argo CD troubleshooting and sync verification steps
- Document rollback and recovery procedure in README
