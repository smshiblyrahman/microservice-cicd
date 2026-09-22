# Project 2 — Complete CI/CD Pipeline for Microservices Deployment

## SELISE-Oriented Technical Implementation Plan

## 1. Project Purpose

This project demonstrates how a software engineering team can move from Git commit to a controlled production deployment with automated quality, security, testing, containerization, and rollback.

The supplied project uses GitHub protected branches, GitHub Actions, SonarQube, unit tests, Docker, Trivy, ACR, semantic versioning, Azure DevOps, AKS, Helm, blue-green deployments, rollback, health checks, smoke tests, Slack, and Azure Monitor. fileciteturn0file0L71-L99

SELISE's current SysOps role emphasizes CI/CD workflows, GitHub repository management/access/deployments, infrastructure automation, operational tooling, and incident support. citeturn0search0

SELISE also publicly identifies Docker, Kubernetes, Jenkins, Terraform, and Ansible among its DevOps technology expertise, so the project should be designed with portable CI/CD concepts rather than coupling every concept to one vendor tool. citeturn0search6

## 2. Target Delivery Flow

```text
Developer
   |
GitHub Pull Request
   |
Lint + Unit Test + Static Analysis
   |
Security Scan
   |
Docker Build
   |
Image Scan
   |
ACR
   |
Deploy Dev
   |
Integration + Smoke Tests
   |
Staging
   |
Approval / Release Gate
   |
Production Blue-Green
   |
Health Validation
   |
Traffic Switch
   |
Monitor
   |
Rollback if necessary
```

## 3. Microservices

The supplied architecture contains:

- User Service — Node.js.
- Product Service — Python/Flask.
- Order Service — Node.js.
- Payment Service — Python.
- Nginx API Gateway. fileciteturn0file0L88-L93

## 4. Repository Design

```text
microservices-cicd-pipeline/
├── services/
│   ├── user-service/
│   ├── product-service/
│   ├── order-service/
│   └── payment-service/
├── gateway/
├── helm/
├── tests/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── security.yml
│       └── release.yml
├── deployment/
│   ├── azure-devops/
│   └── scripts/
└── docs/
```

## 5. Branching Strategy

```text
feature/*
   |
Pull Request
   |
CI
   |
Review
   |
main
   |
Release tag
```

Protect `main`.

Require:

- CI success.
- Review.
- Security checks.
- No unresolved critical findings.

## 6. CI Pipeline Stages

### Stage 1 — Source

- Checkout.
- Determine commit SHA.
- Determine version.
- Restore dependencies.

### Stage 2 — Quality

- Lint.
- Formatting.
- SonarQube analysis.

### Stage 3 — Testing

- Unit tests.
- Coverage.
- Service integration tests where practical.

### Stage 4 — Build

- Docker multi-stage build.

### Stage 5 — Security

- Trivy image scan.
- Dependency/security scan.

### Stage 6 — Registry

- Authenticate to ACR.
- Push immutable image.

## 7. Quality Gates

A production pipeline should block promotion when:

```text
Unit tests fail
OR
Quality gate fails
OR
Critical vulnerability detected
OR
Image cannot be built
```

The exact vulnerability thresholds should be documented and agreed upon.

## 8. Image Tagging

Use:

```text
service:1.4.0
service:1.4.0-<commit-sha>
```

Production should reference immutable versions.

Avoid making `latest` the production deployment contract.

## 9. Test Strategy

```text
Unit
  ↓
Service integration
  ↓
Container integration
  ↓
Deployment smoke
  ↓
Production health checks
```

Test business-critical flows:

```text
User registration
Login
Product retrieval
Order creation
Payment request
```

The actual application contract should determine exact tests.

## 10. Helm

Structure:

```text
helm/
└── ecommerce/
    ├── Chart.yaml
    ├── values.yaml
    ├── values-dev.yaml
    ├── values-staging.yaml
    ├── values-prod.yaml
    └── templates/
```

Never commit production secrets into values files.

## 11. Blue-Green Deployment

```text
                 Ingress
                   |
             Traffic Router
               /       \
           BLUE         GREEN
         v1.3.0       v1.4.0
```

Process:

1. Blue remains active.
2. Green is deployed.
3. Green readiness is verified.
4. Smoke tests execute.
5. Production metrics are checked.
6. Traffic moves to Green.
7. Blue remains available for rollback.
8. Blue is retired after a defined stabilization window.

## 12. Rollback

Rollback should be a normal engineering operation, not an emergency improvisation.

Triggers:

- Smoke-test failure.
- Readiness failure.
- Error-rate spike.
- Latency regression.
- CrashLoopBackOff.
- Critical security issue.

Rollback flow:

```text
Detect
 ↓
Validate
 ↓
Stop promotion
 ↓
Restore previous version
 ↓
Health check
 ↓
Notify
 ↓
Create incident/RCA
```

## 13. Environment Promotion

```text
Dev
 ↓
Automated validation
 ↓
Staging
 ↓
Release gate
 ↓
Production
```

Do not build a different artifact for each environment. Promote the same immutable artifact whenever possible.

## 14. Secrets

Secrets should come from the security architecture in Project 5.

Recommended relationship:

```text
Pipeline
   |
Managed identity / secure connection
   |
Azure Key Vault
   |
Deployment
   |
AKS
```

Avoid:

```text
GitHub repository
   |
hardcoded secret
```

## 15. GitHub/Azure DevOps Boundary

Because the supplied project uses GitHub Actions for CI and Azure DevOps for CD, document the boundary explicitly:

```text
GitHub
  = source + CI

Azure DevOps
  = release/deployment orchestration
```

This is useful interview material because it demonstrates that the engineer understands **pipeline responsibilities**, not merely tool syntax.

For an organization using GitLab/Jenkins or another CI platform, the same stages can be transferred without changing the underlying delivery model.

## 16. Deployment Observability

After deployment collect:

- Version.
- Commit SHA.
- Environment.
- Deployment start/end.
- Health status.
- Smoke-test result.
- Error rate.
- Latency.
- Rollback status.

The supplied project integrates Azure Monitor for deployment tracking. fileciteturn0file0L95-L99

## 17. Notifications

Slack message:

```text
Deployment: SUCCESS
Service: order-service
Version: 1.4.0
Environment: staging
Commit: abc123
Duration: 04m 18s
Smoke Tests: PASSED
```

Failure notification should include the failed stage and a link to logs.

## 18. Implementation Plan

### Week 1

- Repository.
- Branch protection.
- Tests.
- Dockerfiles.
- CI.

### Week 2

- SonarQube.
- Trivy.
- ACR.
- Versioning.
- Artifact strategy.

### Week 3

- Helm.
- AKS.
- Environment values.
- Deployment scripts.

### Week 4

- Blue-green.
- Rollback.
- Notifications.
- Monitoring.
- Production runbook.

## 19. SELISE Alignment Checklist

```text
[ ] Git repository management
[ ] CI/CD automation
[ ] Infrastructure-aware deployment
[ ] Docker
[ ] Kubernetes
[ ] Helm
[ ] Azure
[ ] Security scanning
[ ] Deployment troubleshooting
[ ] Monitoring
[ ] Release documentation
[ ] Incident/rollback procedure
```

## 20. Evidence

GitHub should contain:

```text
.github/workflows/
helm/
Dockerfiles
test suites
security reports
deployment documentation
rollback runbook
architecture diagram
sample pipeline screenshots
```

## 21. Interview Questions

1. What happens after a developer opens a PR?
2. Why separate CI and CD?
3. Why scan before pushing/promoting images?
4. Why use immutable image tags?
5. How does blue-green reduce deployment risk?
6. What happens if smoke tests fail?
7. How do you prevent secrets leaking into pipeline logs?
8. How would you debug a deployment that works locally but fails in AKS?
9. How do you measure deployment reliability?
10. How would you migrate this pipeline from GitHub Actions to GitLab/Jenkins?
