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

## 📌 Terraform State (Production Recommendation)

Production setups must use:

- **S3 bucket** for remote Terraform state
- **DynamoDB table** for state‑locking

For demo purposes this repo keeps state **local**, but switching to S3+DynamoDB requires only updating the backend block.

---

## 1. Architecture Overview

```
Terraform → AWS infra → cloud‑init → Ansible → Docker → Full app stack
```

```mermaid
flowchart TD
    A[Terraform Apply] --> B[VPC + Subnet + Route Table]
    A --> C[EC2 Instance]
    A --> D[Generate hosts.ini]

    C --> E[cloud-init bootstrap]
    E --> F[Ansible Playbook]

    F --> G[Docker Install Role]
    F --> H[Python Demo App Role]

    H --> I[Docker Compose Stack]
```

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
│   │   └── python-demo-app/             # Deploys Python app + Nginx + Docker Compose
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
- Ensures the repo is always deployable, formatted, and compliant

---

## 4. Usage

### Step 1 – Configure AWS credentials

Either:

- AWS SSO
- or access keys
- or env variables  
  (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)

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
- Python demo app
- Nginx reverse proxy
- SSL (self‑signed)
- Complete Docker Compose stack under `/opt/app`

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
