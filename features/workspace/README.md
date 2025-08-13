## Terraform Workspaces

### 🌟 What is a Workspace?

A **Terraform workspace** is a way to have **multiple state files** for the same Terraform configuration.
This lets you **manage multiple environments** (like dev, staging, prod) **from the same code**.

Think of it like:

> Same blueprint 🏗, different houses 🏠🏡🏢 for different purposes.

---

### 🤔 Why Use Workspaces?

* **Environment isolation** → Keep dev, staging, prod separate.
* **Same code, different state** → No need to copy-paste `.tf` files.
* **Avoid resource conflicts** → Separate state files mean no accidental overwrites.

---

### 🛠 Example: Workspaces in Action

#### Step 1 — Create a New Workspace

```bash
terraform workspace new dev
terraform workspace new prod
```

#### Step 2 — List Workspaces

```bash
terraform workspace list
```

#### Step 3 — Switch Workspace

```bash
terraform workspace select dev
```

#### Step 4 — Use Workspace in Code

You can reference the active workspace inside Terraform:

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-${terraform.workspace}"
}
```

If workspace is `dev`, bucket name becomes:
`my-bucket-dev`
If workspace is `prod`, bucket name becomes:
`my-bucket-prod`

---

## 📋 Key Differences — Modules vs Workspaces

| Feature     | Modules 📦                        | Workspaces 🗂                         |
| ----------- | --------------------------------- | ------------------------------------- |
| Purpose     | Reusable infrastructure code      | Multiple environments using same code |
| Scope       | Groups of resources               | Entire Terraform project state        |
| Helps with  | Code reusability, organization    | Environment isolation                 |
| Example Use | EC2 setup module for all projects | Separate state for dev/staging/prod   |

---

## Reference 

https://developer.hashicorp.com/terraform/language/state/workspaces
