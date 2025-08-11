# Infrastructure as Code (IaC) with Terraform

This repository contains examples, best practices, and reusable modules for managing cloud infrastructure using **Infrastructure as Code (IaC)** with **Terraform**.

---

## 📌 Introduction

Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure through machine-readable configuration files, rather than manual processes.  
With IaC, you can:
- Version control your infrastructure.
- Automate provisioning and configuration.
- Ensure consistency across environments.

**Terraform** is an open-source IaC tool that enables you to define cloud and on-prem resources using a declarative configuration language (HCL – HashiCorp Configuration Language).

---

## 🚀 Getting Started

### 1 Prerequisites
Before you start, ensure you have:
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed
- AWS Account with IAM credentials (Access Key & Secret Key)
- Git installed for version control

### 2 Clone the Repository
```bash
git clone https://github.com/<your-username>/<repo-name>.git
cd <repo-name>
```

### 3 Initialize Terraform
```bash
terraform init
```
### 4 Validate Configuration
```bash
terraform validate
```
### 5 Plan Changes
```bash
terraform plan
```
### 6 Apply Changes
```bash
terraform apply 
```
### 7 Destory changes
```bash
terraform destory
```
