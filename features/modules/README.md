## Terraform Modules

### 🌟 What is a Module?

A **Terraform module** is just a **container for Terraform code** — a way to group related resources together so you can reuse them.

Think of it like:

> Saving your favorite recipe 📜 so you can cook the same meal 🍝 anytime without guessing the ingredients again.

---

### 🤔 Why Use Modules?

* **Reusability** → Write once, use anywhere
* **Organization** → Cleaner, modular code
* **Consistency** → Same standards across projects
* **Teamwork** → Easy sharing of infrastructure patterns

---

### 🛠 Example: Simple EC2 Module

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
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

**`modules/ec2/outputs.tf`**:

```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```

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

Run:

```bash
terraform init
terraform apply
```

# Reference

https://developer.hashicorp.com/terraform/language/modules
