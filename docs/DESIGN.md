# Design Note

## Overview
This solution deploys a simple multi-service application to Kubernetes using Helm for packaging and Argo CD for GitOps-based delivery. The application consists of:
- frontend service
- backend API service

The cluster used for this assignment is a local Kubernetes environment based on k3s.

## Repository Structure
```text
SRE-Assingment/
├── apps/
├── helm/
│   ├── frontend-chart/
│   └── backend-chart/
├── argocd/
│   ├── application.yaml
│   └── backend-application.yaml
├── gateway/
│   ├── gateway.yaml
│   └── httproute.yaml
├── docs/
│   ├── DESIGN.md
│   └── RCA.md
└── README.md
