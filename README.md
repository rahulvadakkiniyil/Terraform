## 📌 What is Infrastructure as Code (IaC)?

**Infrastructure as Code** is a way to **manage and provision your IT infrastructure using code** instead of clicking around in a cloud provider’s dashboard.

Think of it like this:

> Instead of cooking a meal without a recipe 🍲, you write the recipe down 📜 so you can cook the same meal again, perfectly, every time.

---

## 🚀 Why IaC is Awesome

* **Consistency** — No more “it works on my machine” problems.
* **Repeatability** — Deploy the same setup across environments (dev, staging, prod).
* **Version Control** — Track changes with Git just like you do with application code.
* **Speed** — Deploy infrastructure in minutes instead of hours or days.
* **Automation** — Integrate with CI/CD pipelines for fully automated deployments.

---

## 🛠 Popular IaC Tools

* **Terraform** (multi-cloud, open-source)
* AWS CloudFormation (AWS only)
* Azure Resource Manager Templates (Azure only)
* Google Cloud Deployment Manager (GCP only)
* Pulumi (IaC with general-purpose languages)

---

## 🌱 What is Terraform?

**Terraform** is an open-source IaC tool created by **HashiCorp** that lets you define, provision, and manage cloud infrastructure using **HCL (HashiCorp Configuration Language)**.

---

## 💡 Why Terraform?

* **Cloud-agnostic** — Works with AWS, Azure, GCP, and many other providers.
* **Declarative** — You tell Terraform *what* you want, not *how* to build it.
* **State management** — Tracks resources it created using a **state file**.
* **Reusable** — Use modules to avoid repeating code.

---

## 📋 Example: Terraform in Action

Let’s say we want to create an AWS EC2 instance.

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_vm" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

---

## ⚙️ How Terraform Works

1. **Write** the configuration in `.tf` files.
2. **Initialize** Terraform:

   ```bash
   terraform init
   ```
3. **Plan** the changes:

   ```bash
   terraform plan
   ```
4. **Apply** to create resources:

   ```bash
   terraform apply
   ```
5. **Destroy** resources when not needed:

   ```bash
   terraform destroy
   ```

# Reference

* https://www.udemy.com/course/master-terraform-with-aws/learn/lecture/15635128?start=45#overview
* https://github.com/terraform-aws-modules
