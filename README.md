# DevOps AWS Terraform + Ansible Stack

<p>
  <img src="https://img.shields.io/badge/Terraform-5C4EE5?logo=terraform&logoColor=white" />
  <img src="https://img.shields.io/badge/Ansible-EE0000?logo=ansible&logoColor=white" />
  <img src="https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white" />
  <img src="https://img.shields.io/badge/AWS-FF9900?logo=amazon-aws&logoColor=white" />
</p>

<p>
  <img src="https://github.com/LaurisNeimanis/ccore-ai-infra/actions/workflows/terraform-ci.yml/badge.svg" />
  <img src="https://github.com/LaurisNeimanis/ccore-ai-infra/actions/workflows/ansible-lint.yml/badge.svg" />
</p>

Infrastructure-as-Code templates for AWS using **Terraform** and **Ansible**.  
This repository demonstrates a clean, production‑grade DevOps workflow.

- AWS VPC + networking
- EC2 provisioning
- Secure bootstrap using cloud-init
- Automated configuration with Ansible
- Environment separation (dev / prod)
- CI examples for Terraform & Ansible

The goal is to showcase real DevOps engineering practices in a minimal, reproducible form.

---

## Application Integration (ccore-ai-demo)

This infrastructure stack deploys the application layer from a separate repository:

🔗 https://github.com/LaurisNeimanis/ccore-ai-demo

The EC2 instance uses **pre-built Docker images** from GHCR:

- `ghcr.io/laurisneimanis/ccore-ai-demo-backend:latest`
- `ghcr.io/laurisneimanis/ccore-ai-demo-frontend:latest`

No application build happens on EC2 — deployment is fully pull-based.

Security groups follow the principle of least privilege, exposing only HTTPS to the public internet.

---

## 📌 Terraform State (Production Recommendation)

Production setups must use:

- **S3 bucket** for remote Terraform state
- **DynamoDB table** for state‑locking

For demo purposes this repo keeps state **local**, but switching to S3+DynamoDB requires only updating the backend block.

---

## Prerequisites

- Terraform ≥ 1.6
- Ansible ≥ 2.15
- AWS CLI configured (SSO or access keys)
- Ansible-compatible SSH access to EC2 (cloud-init enables this automatically)
- GitHub Actions runners (provided by GitHub)

---

## 1. Architecture Overview

```
Terraform → AWS infra → cloud‑init → Ansible → Docker → GHCR images → Full app stack
```

EC2 instances are bootstrapped via cloud-init, which installs Python3 and ensures the instance is ready for Ansible (marker file: `/var/log/bootstrap_ready.log`).

```mermaid
flowchart TD
    A[Terraform Apply] --> B[VPC + Subnet + Route Table]
    A --> C[EC2 Instance]
    A --> D[Generate hosts.ini]

    C --> E[cloud-init bootstrap]
    E --> F[Ansible Playbook]

    F --> G[Docker Install Role]
    F --> H["App Deployment (GHCR Images)"]

    H --> I[Docker Compose Stack]
    I --> J[Backend + Frontend from ccore-ai-demo]
```

> **Full detailed diagram:** see `diagrams/architecture.mmd`

---

## 2. Folder Structure

```
ccore-ai-infra/
├── terraform/                           # Infrastructure-as-Code (AWS) using Terraform
│   ├── modules/                         # Reusable Terraform modules (clean separation)
│   │   ├── network/                     # VPC, subnets, routing, security groups
│   │   └── compute/                     # EC2 instance module
│   ├── envs/                            # Environment-specific Terraform stacks
│   │   ├── dev/                         # Dev environment Terraform configuration
│   │   └── prod/                        # Prod environment Terraform configuration
│   └── README.md                        # Documentation for using Terraform in this repo
│
├── ansible/                             # Server configuration / provisioning layer
│   ├── inventory/
│   │   └── hosts.ini                    # Auto-generated list of EC2 hosts from Terraform output
│   ├── roles/                           # Modular Ansible roles
│   │   ├── docker-install/              # Installs Docker Engine + dependencies
│   │   └── app-deployment/              # Deploys backend + frontend via GHCR + Nginx + Docker Compose
│   ├── playbook.yml                     # Entry point playbook executed by CI or locally
│   └── README.md                        # Documentation for the Ansible setup
│
├── diagrams/
│   └── architecture.mmd                 # Mermaid diagram describing full infra architecture
│
├── .github/
│   └── workflows/                       # GitHub Actions CI/CD pipelines
│       ├── ansible-lint.yml             # Lints all Ansible roles, tasks, templates
│       └── terraform-ci.yml             # Terraform fmt/validate/plan pipeline
│
├── LICENSE                              # Repository license
└── README.md                            # Main documentation covering whole stack
```

Terraform provisions infra → then generates:

```
ansible/inventory/hosts.ini
```

Example:

```
[app]
3.67.196.100 ansible_user=ubuntu
```

---

## 3. CI Status

- **Terraform CI** – validates Terraform formatting, syntax, init, and plan
- **Ansible Lint** – validates playbooks, roles, templates, structure
- **CI pipeline** runs automatically on push / PR  
  Ensures the repo is always deployable, formatted, and compliant.

---

## 4. Usage

### Step 1 – Configure AWS credentials

Either:

- AWS SSO
- or access keys
- or env variables:  
  `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`

### Step 2 – Initialize Terraform

```
cd terraform/envs/dev
terraform init
```

### Step 3 – Apply infrastructure

```
terraform apply
```

### Step 4 – Run Ansible provisioning

```
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbook.yml
```

This installs:

- Docker Engine
- Docker Compose plugin
- Nginx reverse proxy
- SSL (self-signed, auto-generated in demo mode)
- Pulls latest production images from GHCR
- Deploys full backend + frontend stack under `/opt/ccore-ai`

---

### Redeploy After New Image Builds

When **ccore-ai-demo** pushes a new container image, update EC2 with:

```
docker compose -f /opt/ccore-ai/docker-compose.yml pull
docker compose -f /opt/ccore-ai/docker-compose.yml up -d
```

The Ansible playbook is fully idempotent — it can be executed multiple times safely.
Re-running the playbook will simply pull newer images (if available) and update the stack without breaking existing configuration.

---

## 5. Technologies Used

- Terraform
- Ansible
- Docker & Docker Compose
- AWS EC2 / VPC / IAM
- cloud‑init
- GitHub Actions CI

---

## 6. Purpose

Designed to:

- Demonstrate real DevOps workflows
- Provide reusable AWS IaC templates
- Serve as a training/portfolio project
- Maintain clarity + minimalism

---

## 7. License

MIT License.
