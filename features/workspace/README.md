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

## 🎯 Best Practices

* Use **modules** to avoid repeating code across projects.
* Use **workspaces** for environment separation — but for complex setups, consider separate folders or repositories.
* Combine both:

  * A module defines *how* infrastructure is built.
  * A workspace decides *where* and *for which environment* it is built.

---

💡 **Pro Tip**:
Many teams use **modules + workspaces** with a remote backend (like AWS S3 + DynamoDB) so multiple engineers can safely work on infrastructure together.

---

If you want, I can make a **hands-on lab README** that shows how to create an AWS EC2 **module**, and then deploy it in **dev** and **prod** environments using **workspaces** — so it’s a real-world, end-to-end example. Would you like me to prepare that next?

