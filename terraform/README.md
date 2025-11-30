# Terraform AWS Infrastructure (Modular, Production-Grade)

This repository contains a **production-oriented AWS Infrastructure-as-Code setup**, built using **Terraform** and **official terraform-aws-modules**, following modern DevOps patterns:

- Clean separation between configuration (envs) and logic (modules replaced with AWS official modules)
- Clean dependency flow (VPC → SG → EC2)
- Cloud-init–based provisioning bootstrap for Ansible
- Declarative inventory generation
- Clear, reproducible, cloud-ready IaC design

This reflects architecture used across real-world DevOps, SRE, and Cloud Engineering environments.

---

# 1. Directory Structure

```
terraform/
├── envs/
│   └── dev/
│       ├── backend.tf           # Local backend (demo only)
│       ├── main.tf              # VPC + SG + EC2 using official AWS modules
│       ├── variables.tf         # Inputs
│       ├── locals.tf            # Tags, naming
│       ├── outputs.tf           # Env-level outputs
│       ├── data.tf              # SSM AMI lookups
│       ├── inventory.tf         # Terraform → Ansible inventory
│       ├── keypair.tf           # EC2 key pair
│       ├── terraform.tfvars     # Environment variables
│       ├── bootstrap/
│       │    └── bootstrap.yaml  # Cloud-init provisioning
│       └── templates/
│           └── inventory.tmpl   # Inventory template
│
└── README.md
```

**Official AWS modules provide all VPC, SG, and EC2 logic.**  
**Environments contain configuration + wiring only.**

---

# 2. How It Works (High-Level Architecture)

This infrastructure provisions:

### **Network Layer (terraform-aws-modules/vpc)**
- VPC
- Public Subnet
- Internet Gateway
- Route Table + association
- Structured resource tagging
- Optional IPv6 support

### **Security Group Layer (terraform-aws-modules/security-group)**

- SSH from restricted CIDR
- HTTP/HTTPS open
- Optional IPv6 ingress/egress

### **Compute Layer (terraform-aws-modules/ec2-instance)**

- Latest Ubuntu 24.04 AMI from SSM Parameter Store
- EC2 instance (t3.micro by default)
- Public IPv4 + optional IPv6
- Cloud-init provisioning (user_data YAML)
- Hardened metadata (IMDSv2)

### **Integration Layer (envs/dev)**

- Wires VPC → SG → EC2
- Generates Ansible inventory from instance IP

---

# 3. Auto-Generated Ansible Inventory

Terraform produces:

```
ansible/inventory/hosts.yaml
```

Example:

```yaml
all:
  hosts:
    app:
      ansible_host: 3.120.88.15
      ansible_user: ubuntu
```

**Benefits:**
- Always correct
- Zero manual edits
- Safe via `.gitignore`
- Enables instant provisioning

---

# 4. Cloud-Init Provisioning (bootstrap.yaml)

Executed via EC2 `user_data`:

- Updates APT
- Installs Python3 (required by Ansible)
- Ensures SSH server is installed & running
- Completes fully before Ansible via:
  ```
  cloud-init status --wait
  ```

This is **modern best practice** and completely replaces old `bootstrap.sh`.

---

# 5. Usage

### Select environment
```
cd terraform/envs/dev
```

### Initialize
```
terraform init
```

### Plan
```
terraform plan
```

### Apply
```
terraform apply
```

---

# 6. Architecture Diagram

```mermaid
flowchart TD
    A[envs/dev/main.tf] --> B[terraform-aws-modules/vpc]
    A --> C[terraform-aws-modules/security-group]
    A --> D[terraform-aws-modules/ec2-instance]
    A --> E[local_file: ansible/inventory/hosts.yaml]

    B --> VPC[VPC]
    B --> SUB[Public Subnet]
    B --> IGW[Internet Gateway]
    B --> RT[Route Table]

    C --> SG[Security Group]

    D --> AMI["Ubuntu AMI Lookup (SSM)"]
    D --> EC2[EC2 Instance]
    D --> CI[Cloud-init YAML]

    EC2 --> INV[Generated Ansible Inventory]
```

---

# 7. CIDR & AZ Layout

```
VPC:       10.10.0.0/16
Subnet:    10.10.1.0/24
AZ:        eu-central-1a
```

---

# 8. Extensibility

Supports upgrades into:

- Multi-AZ networking
- NAT gateways
- RDS / ElastiCache
- S3 & IAM policies
- ALB / NLB
- ECS / EKS clusters
- Terraform CI/CD
- Drift detection

---

# 9. Why This Architecture

Demonstrates:

- Senior-level IaC design
- Official AWS module usage (best practice)
- Cloud-init–first provisioning
- Automated Ansible onboarding
- Dynamic AMI lookup
- Clean tagging & naming
- Scalable networking
- Reproducibility and clarity

---

# 10. Summary

A clean, modern AWS IaC foundation with:

- Official AWS modules (VPC, SG, EC2)
- Cloud-init compute provisioning
- Automatic inventory generation
- Clear separation of concerns

Minimal. Clean. Production-ready.
