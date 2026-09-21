# RetailFlow DevOps Platform

> End-to-end Azure DevOps platform for automated, secure, observable, and scalable deployment of a containerized retail e-commerce application.

[![Azure](https://img.shields.io/badge/Azure-Cloud-blue?logo=microsoftazure)](https://azure.microsoft.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-Containers-2496ED?logo=docker)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?logo=kubernetes)](https://kubernetes.io/)
[![AKS](https://img.shields.io/badge/AKS-Azure%20Kubernetes%20Service-0078D4?logo=microsoftazure)](https://azure.microsoft.com/products/kubernetes-service)
[![Azure DevOps](https://img.shields.io/badge/Azure%20DevOps-CI%2FCD-0078D7?logo=azuredevops)](https://azure.microsoft.com/products/devops)

---

## Overview

**RetailFlow** is an end-to-end DevOps platform designed for a sporting-goods e-commerce application.

The project addresses a traditional deployment model where infrastructure provisioning, application deployments, scaling, troubleshooting, and recovery depend heavily on manual operations.

The platform replaces that workflow with:

* Infrastructure as Code using Terraform
* Containerized application delivery using Docker
* Azure Container Registry for immutable container images
* Azure Kubernetes Service for application orchestration
* Automated Azure DevOps CI/CD pipelines
* Separate `dev` and `prod` Kubernetes environments
* Role-based access and workload identity
* Azure Key Vault for protected secrets
* Monitoring, centralized logging, and alerting
* Horizontal Pod Autoscaling
* Kubernetes rolling deployments and rollback
* Infrastructure drift detection and recovery

The project focuses on **platform engineering and operational reliability**, rather than application complexity.

---

## Architecture

```text
                              USERS
                                |
                                v
                         Public Endpoint
                                |
                                v
                             Ingress
                                |
                                v
                       Kubernetes Service
                                |
                                v
                        Flask Application
                           Pods in AKS
                         /           \
                        /             \
                       v               v
                    Redis          PostgreSQL
```

### Azure Platform

```text
                           Microsoft Azure
                                 |
        +------------------------+------------------------+
        |                        |                        |
        v                        v                        v
   Resource Group              VNet                    ACR
        |                        |                        |
        |                  +-----+-----+                  |
        |                  |           |                  |
        |               AKS Subnet   Supporting           |
        |                  |         Resources             |
        |                  v                              |
        |                 AKS <----------------------------+
        |                  |
        |          +-------+-------+
        |          |               |
        |         dev             prod
        |      namespace       namespace
        |
        +---- Key Vault
        |
        +---- Log Analytics
        |
        +---- Azure Monitor
        |
        +---- PostgreSQL
        |
        +---- Terraform State
```

---

## CI/CD Pipeline

Application delivery follows a controlled promotion workflow:

```text
Developer
    |
    v
Feature Branch
    |
    v
Pull Request
    |
    v
Code Review
    |
    v
main
    |
    v
Azure DevOps Pipeline
    |
    +---- Validation
    |
    +---- Unit Tests
    |
    +---- Security Checks
    |
    +---- Docker Build
    |
    +---- Container Scan
    |
    v
Azure Container Registry
    |
    v
Deploy to DEV
    |
    v
Smoke Tests
    |
    v
Production Approval
    |
    v
Deploy to PROD
    |
    v
Post-Deployment Validation
```

Container images are identified using immutable build/version identifiers such as the Git commit SHA rather than relying on a mutable `latest` tag.

Example:

```text
retailflow-api:<git-commit-sha>
```

This allows a production deployment to be traced back to a specific source-code revision.

---

## Infrastructure as Code

Terraform is used to provision and manage the Azure platform.

The infrastructure is organized into reusable modules and environment-specific configurations.

```text
terraform/
├── modules/
│   ├── resource-group/
│   ├── networking/
│   ├── acr/
│   ├── aks/
│   ├── keyvault/
│   └── monitoring/
│
└── environments/
    ├── dev/
    └── prod/
```

Terraform manages the infrastructure lifecycle, while Kubernetes manifests and Azure DevOps pipelines manage application deployment.

### Key Infrastructure Components

| Component            | Purpose                     |
| -------------------- | --------------------------- |
| Azure Resource Group | Resource organization       |
| Azure VNet           | Network isolation           |
| AKS                  | Container orchestration     |
| ACR                  | Container image storage     |
| Key Vault            | Secret management           |
| Log Analytics        | Centralized logging         |
| Azure Monitor        | Monitoring and alerting     |
| Azure Storage        | Remote Terraform state      |
| PostgreSQL           | Persistent application data |

---

## Kubernetes

The initial platform uses a shared AKS cluster with isolated namespaces:

```text
AKS
├── dev
│   └── RetailFlow Application
│
└── prod
    └── RetailFlow Application
```

The application deployment includes Kubernetes capabilities such as:

* Deployments
* Services
* ConfigMaps
* Service Accounts
* Resource requests and limits
* Readiness probes
* Liveness probes
* Horizontal Pod Autoscaling
* Rolling deployments
* Versioned releases
* Rollback

Production and development are logically separated at the namespace level.

For stronger isolation requirements, the architecture can evolve toward separate AKS clusters.

---

## Application

The initial application is a lightweight Python Flask service designed to provide a realistic workload for the DevOps platform.

Example endpoints:

```text
GET /
GET /health
```

The application architecture includes:

```text
Flask Application
       |
       +---- Redis
       |
       +---- PostgreSQL
```

The application itself is intentionally simple so that the primary focus remains on:

* Infrastructure automation
* CI/CD
* Kubernetes operations
* Security
* Observability
* Scaling
* Reliability
* Incident response

---

## Security

Security is implemented using Azure-native identity and access controls.

### Identity & Access

```text
Microsoft Entra ID
        |
        v
    Azure RBAC
        |
        v
Azure Resources
```

The AKS platform uses:

* Azure RBAC
* Kubernetes RBAC
* Workload Identity
* OIDC issuer
* Managed identities
* Least-privilege access

### Workload Identity

Application workloads can authenticate to Azure services without relying on long-lived credentials.

```text
AKS Workload
     |
     v
Kubernetes Service Account
     |
     v
Workload Identity
     |
     v
Azure Identity / RBAC
     |
     v
Azure Key Vault
```

Secrets are not intended to be hard-coded into application source code, container images, or deployment configuration.

---

## Observability

The platform provides observability across infrastructure, Kubernetes, and application layers.

```text
Application / Kubernetes / Infrastructure
                  |
                  v
            Metrics + Logs
                  |
        +---------+---------+
        |                   |
        v                   v
   Prometheus          Azure Monitor
        |                   |
        v                   v
     Grafana          Log Analytics
        |
        v
    Dashboards
        |
        v
     Alerts
```

### Infrastructure

* CPU utilization
* Memory utilization
* Node health
* Resource consumption

### Kubernetes

* Pod health
* Pod restarts
* Deployment status
* Replica count
* Node status
* HPA behavior

### Application

* Request health
* HTTP status codes
* Application errors
* Response behavior

Centralized logs are available through Azure monitoring and Log Analytics for troubleshooting and incident investigation.

---

## Auto Scaling

The application uses Kubernetes Horizontal Pod Autoscaling.

The HPA is configured to respond to application workload and CPU utilization.

Example scaling configuration:

```text
Minimum replicas: 1
Maximum replicas: 3
Target CPU: 70%
```

Scaling behavior was tested by generating controlled workload and verifying both scale-up and scale-down behavior.

---

## Deployment & Rollback

Application deployments use Kubernetes rolling updates.

```text
Current Version
      |
      v
New Version
      |
      v
Readiness Checks
      |
      v
Gradual Pod Replacement
      |
      v
Health Validation
      |
      v
Deployment Complete
```

If a release causes problems, Kubernetes can return the workload to a previously known-good revision.

```text
Failed Release
      |
      v
Detection
      |
      v
Investigation
      |
      v
Rollback
      |
      v
Previous Version
      |
      v
Health Validation
```

Rollback and application health recovery were verified as part of the platform validation.

---

## Reliability & Self-Healing

Kubernetes provides automatic workload recovery mechanisms.

The platform was validated against operational scenarios including:

* Pod failure
* Application health failure
* Container restart
* Deployment recovery
* Service continuity
* Rollback
* HPA scaling behavior

Health probes allow Kubernetes to distinguish healthy workloads from workloads that should be restarted or removed from service.

---

## Infrastructure Drift

Terraform is used not only to provision infrastructure but also to identify configuration drift.

The project validated drift detection by modifying Azure resource configuration outside Terraform and then using Terraform to identify the difference.

Example workflow:

```text
Terraform Configuration
        |
        v
Azure Infrastructure
        |
        X
Out-of-band Change
        |
        v
terraform plan
        |
        v
Drift Detected
        |
        v
Controlled Correction
```

This demonstrates why Infrastructure as Code is useful beyond initial provisioning.

---

## Repository Structure

```text
retailflow-devops-platform/
│
├── docs/
│   ├── requirements/
│   ├── architecture/
│   ├── incidents/
│   └── runbooks/
│
├── terraform/
│   ├── modules/
│   │   ├── resource-group/
│   │   ├── networking/
│   │   ├── acr/
│   │   ├── aks/
│   │   ├── keyvault/
│   │   └── monitoring/
│   │
│   └── environments/
│       ├── dev/
│       └── prod/
│
├── ansible/
│
├── kubernetes/
│   ├── base/
│   ├── dev/
│   └── prod/
│
├── pipelines/
│
├── application/
│
└── README.md
```

> Directory names may evolve as the platform is maintained; the structure above represents the logical organization of the project.

---

## Key Engineering Outcomes

The project demonstrates practical implementation of:

| Area                    | Implementation                  |
| ----------------------- | ------------------------------- |
| Cloud                   | Microsoft Azure                 |
| Infrastructure as Code  | Terraform                       |
| Containers              | Docker                          |
| Registry                | Azure Container Registry        |
| Orchestration           | Azure Kubernetes Service        |
| CI/CD                   | Azure DevOps Pipelines          |
| Identity                | Microsoft Entra ID / Azure RBAC |
| Workload Authentication | AKS Workload Identity           |
| Secrets                 | Azure Key Vault                 |
| Monitoring              | Azure Monitor                   |
| Logging                 | Log Analytics                   |
| Metrics                 | Prometheus                      |
| Dashboards              | Grafana                         |
| Scaling                 | Kubernetes HPA                  |
| Deployment              | Rolling Updates                 |
| Recovery                | Kubernetes Rollback             |
| Drift Management        | Terraform                       |
| Automation              | Ansible / Bash / PowerShell     |

---

## Validation

The platform was validated through practical operational scenarios rather than only verifying successful deployment.

Validated areas included:

* Terraform provisioning
* Azure resource management
* AKS workload deployment
* ACR integration
* Workload Identity
* Key Vault access
* Application health checks
* Pod self-healing
* Service continuity
* Rolling deployments
* Application rollback
* HPA scale-up and scale-down
* Centralized logging
* Monitoring
* Pod alerts
* Terraform drift detection
* Azure resource drift detection

The project also documents operational failure scenarios and recovery procedures for continued platform development.

---

## Project Goals

The platform was designed around four primary engineering principles:

### 1. Automate

Replace repetitive manual infrastructure and deployment operations with reproducible automation.

### 2. Secure

Use identity, RBAC, workload identity, and managed secret storage instead of direct server access and long-lived credentials.

### 3. Observe

Make application, Kubernetes, and infrastructure behavior visible through metrics, logs, dashboards, and alerts.

### 4. Recover

Design deployments and infrastructure so failures can be detected, investigated, rolled back, and corrected systematically.

---

## Why This Project Matters

RetailFlow is intentionally built as a **production-like DevOps platform rather than a collection of isolated technology demonstrations**.

The project connects:

```text
Infrastructure
      +
Application
      +
CI/CD
      +
Security
      +
Kubernetes
      +
Observability
      +
Scaling
      +
Failure Recovery
```

The objective is not simply to deploy an application to Azure, but to demonstrate how an engineer can **build, operate, troubleshoot, and recover a cloud-native platform**.

---

## Documentation

Detailed project documentation covers:

* Business requirements
* Platform architecture
* Infrastructure design
* Terraform implementation
* CI/CD workflows
* Kubernetes deployment
* Security architecture
* Monitoring and logging
* Incident investigation
* Failure scenarios
* Recovery procedures
* Operational decisions

See the [`docs/`](docs/) directory for the detailed documentation.

---

## Technology Stack

```text
Cloud
└── Microsoft Azure

Infrastructure
├── Terraform
├── Azure VNet
├── Azure Storage
└── Azure RBAC

Containers
├── Docker
└── Azure Container Registry

Orchestration
└── Azure Kubernetes Service

CI/CD
└── Azure DevOps

Security
├── Microsoft Entra ID
├── Azure RBAC
├── Workload Identity
└── Azure Key Vault

Observability
├── Azure Monitor
├── Log Analytics
├── Prometheus
└── Grafana

Application
├── Python
├── Flask
├── Redis
└── PostgreSQL

Automation
├── Ansible
├── Bash
└── PowerShell
```

---

## Status

**Project Status: Completed**

The core platform has been implemented and validated across infrastructure provisioning, container deployment, Kubernetes operations, CI/CD, security, observability, scaling, rollback, and infrastructure drift scenarios.

Further production-hardening areas such as full disaster-recovery/data-restore exercises and additional cost-optimization scenarios can be developed independently from the completed core platform.

---

## Author

**Sathvik**

DevOps / Cloud Engineering Project

**Primary focus:** Azure • Terraform • Kubernetes • CI/CD • Cloud Infrastructure • DevOps Automation
