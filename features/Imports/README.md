# 📦 Terraform Modules — Beginner’s Guide

## 🌟 What is a Terraform Module?

A **Terraform module** is just a **container for Terraform configuration files**.
It groups related resources together so you can **reuse and share** them across different projects.

Think of it like this:

> Instead of rebuilding a Lego car 🚗 from scratch every time, you keep the design in a box 📦 and reuse it whenever you need.

---

## 🤔 Why Use Modules?

* **Reusability** → Write once, use multiple times
* **Organization** → Break big projects into smaller, easier-to-manage parts
* **Consistency** → Apply the same standards across environments
* **Collaboration** → Share modules with your team or the Terraform community

---

## 🛠 Types of Modules

1. **Root Module**

   * The main Terraform configuration in your project’s root directory.
   * This is what you run `terraform apply` on.

2. **Child Module**

   * A module that is **called** by another module (often the root module).
   * Can be:

     * **Local** (in a folder inside your project)
     * **Remote** (GitHub, Terraform Registry, etc.)

---

## 📋 Example: Creating and Using a Module

### Step 1 — Create the Module

**Folder Structure**:

```
project/
├── main.tf
├── modules/
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

**`modules/ec2/main.tf`**:

```hcl
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

**`modules/ec2/variables.tf`**:

```hcl
variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}
```

**`modules/ec2/outputs.tf`**:

```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```

---

### Step 2 — Call the Module in the Root Module

**`main.tf`**:

```hcl
provider "aws" {
  region = "us-east-1"
}

module "my_ec2" {
  source        = "./modules/ec2"
  ami_id        = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

---

### Step 3 — Deploy

```bash
terraform init
terraform apply
```

---

## 🔑 Module Sources

You can load a module from:

* **Local path**

  ```hcl
  source = "./modules/ec2"
  ```

# Reference

https://developer.hashicorp.com/terraform/language/modules
