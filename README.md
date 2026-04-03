# SRE Assignment – Kubernetes, GitOps, Observability

## Overview

This project demonstrates deployment and operation of a multi-service application using:

* Kubernetes (k3s)
* Helm
* Argo CD (GitOps)
* Gateway API (basic setup)
* Terraform (conceptual infrastructure setup)

The application consists of:

* Frontend (NGINX)
* Backend API (HTTP Echo)

---

## Architecture

Git → Argo CD → Kubernetes

* Git is the source of truth
* Argo CD syncs desired state
* Kubernetes runs workloads

---

## Deployment Flow

1. Helm charts define frontend and backend
2. Changes pushed to Git
3. Argo CD detects and syncs
4. Kubernetes deploys workloads

---

## Setup Steps

### Verify cluster

```bash
kubectl get nodes
```

### Install Argo CD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Apply applications

```bash
kubectl apply -f argocd/application.yaml
kubectl apply -f argocd/backend-application.yaml
```

---

## Validation

```bash
kubectl get pods
kubectl get svc
kubectl get endpoints
```

---

## Argo CD Monitoring

* UI shows application health
* Sync status indicates drift
* Self-healing ensures consistency

Access UI:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

---

## Incident & Debugging

During testing, backend service routing issues were simulated.

Steps taken:

* Checked pods → running
* Checked service → missing/inconsistent
* Checked endpoints → mismatch

Recovery:

```bash
helm template backend ./helm/backend-chart | kubectl apply -f -
```

---

## GitOps Approach

* All configurations stored in Git
* Argo CD ensures cluster matches Git
* Changes tracked and auditable

---

## Gateway API

Gateway API resources are defined for routing:

* `/` → frontend
* `/api` → backend

---

## Terraform (Bonus)

Terraform used conceptually to:

* provision cluster
* install Argo CD

---

## Key Learnings

* Kubernetes troubleshooting (pods, services, endpoints)
* GitOps workflow using Argo CD
* Helm templating
* Real-world debugging scenarios
