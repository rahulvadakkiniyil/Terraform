# Terraform AWS API Gateway with Lambda Integration

This repository demonstrates how to deploy an **AWS API Gateway** using **Terraform** and integrate it with an **AWS Lambda Function** to build a **serverless API**.
It covers **IAM roles**, **Lambda deployment**, **API Gateway setup**, and **endpoint testing**.

---

## 🚀 Features

* Deploys **API Gateway v2 (HTTP API)** or **API Gateway v1 (REST API)**.
* Integrates **Lambda function** with API Gateway for serverless APIs.
* Configurable **routes**, **stages**, and **HTTP methods**.
* **IAM permissions** automatically managed.
* Outputs a **public HTTPS endpoint** for testing.

## 📝 Example Lambda Function (`lambda_function.py`)

```python
import json

def lambda_handler(event, context):
    path = event.get("rawPath", "/")
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"Hello! You hit the {path} endpoint 🚀",
            "event": event
        }),
    }
```

---

## ⚙️ Terraform Code

### **1. IAM Role for Lambda**

```hcl
resource "aws_iam_role" "lambda_role" {
  name = "lambda_api_gateway_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

---

### **2. Lambda Function**

```hcl
resource "aws_lambda_function" "api_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"
  filename      = "lambda_function.zip"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic]
}
```

---

### **3. API Gateway (HTTP API)**

```hcl
resource "aws_apigatewayv2_api" "http_api" {
  name          = "terraform-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.api_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
```

---

### **4. Variables (`variables.tf`)**

```hcl
variable "lambda_function_name" {
  default = "terraform-api-lambda"
}

variable "environment" {
  default = "dev"
}
```

---

## 📦 Packaging the Lambda

Before running Terraform, package the Lambda code:

```bash
zip lambda_function.zip lambda_function.py
```

---

## 📊 Outputs

```hcl
output "api_gateway_endpoint" {
  value = aws_apigatewayv2_stage.default_stage.invoke_url
}

output "lambda_function_arn" {
  value = aws_lambda_function.api_lambda.arn
}
```

Example:

```bash
api_gateway_endpoint = https://abcd1234.execute-api.us-east-1.amazonaws.com/hello
lambda_function_arn  = arn:aws:lambda:us-east-1:123456789012:function:terraform-api-lambda
```
---

## 📚 References

* [Terraform AWS API Gateway Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api)
* [Terraform AWS API Account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account)
* [Terraform AWS API Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource)
* [Terraform AWS IAM Role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)
* [AWS API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/)
* [AWS Lambda Integration with API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html)
