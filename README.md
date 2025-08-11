## 📦 What is AWS S3?

**Amazon Simple Storage Service (S3)** is an object storage service that provides industry-leading scalability, data availability, security, and performance.  
It is often used for:
- Storing backups, static assets, and large datasets.
- Hosting static websites.
- Serving as a **Terraform remote backend** for state files.

**Key Features of AWS S3:**
- **Scalability** – Store virtually unlimited data.
- **Durability** – 99.999999999% (11 9’s) durability.
- **Security** – IAM policies, bucket policies, and encryption options.
- **Storage Classes** – Standard, Intelligent-Tiering, Glacier, etc.
- **Event Notifications** – Trigger AWS Lambda or other services.

When using Terraform, you can automate bucket creation, lifecycle rules, and permissions to ensure consistent storage management.

## Reference
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
