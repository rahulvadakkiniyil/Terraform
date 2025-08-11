## 📦  Terraform Import — Bring Your Existing Infrastructure into Terraform

When we start using Terraform, most of us think about creating new resources.
But what if your infrastructure already exists? Maybe you have an EC2 instance, an S3 bucket, or a database that you created manually or with another tool.  

## What is Terraform Import?
In simple terms:
terraform import lets you connect an existing resource in your cloud provider to your Terraform code — without recreating it.


## Why use Terraform Import?
You manually created a resource (e.g., in AWS console) and now want Terraform to manage it.

You’re migrating infrastructure from another IaC tool (like CloudFormation or Pulumi) to Terraform.

You inherited infrastructure from another team and want to bring it under Terraform management.

## How terraform Import works
When you run terraform import, Terraform:

Looks at your Terraform configuration to see what type of resource you want to manage.

Fetches the resource from the provider using its ID.

Updates your state file so Terraform knows about the resource.

Important: It does not automatically generate the .tf code — you still have to write it manually.

## Run the Import Command

```bash
terraform import aws_instance.my_vm instance_id
```

## Reference

[https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html](https://developer.hashicorp.com/terraform/cli/import)
