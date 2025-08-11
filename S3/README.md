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

---
## 🌐 What is AWS Elastic IP (EIP)?

An **Elastic IP (EIP)** is a static, public IPv4 address provided by AWS.  
It’s designed for dynamic cloud computing and allows you to:
- Maintain a consistent public IP address even if the underlying instance changes.
- Remap the IP address to another instance in case of failure.
- Avoid DNS changes during migrations or replacements.

**Key Use Cases:**
- Web servers requiring a fixed public IP.
- Disaster recovery failover.
- Load balancer configurations without DNS updates.

**Terraform Benefits:**
You can create, associate, and release EIPs automatically, ensuring consistent IP assignments across deployments.

----

## Reference

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html
