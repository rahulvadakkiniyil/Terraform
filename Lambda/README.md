# Terraform AWS Lambda Function

This repository demonstrates how to deploy an **AWS Lambda Function** using **Terraform**.
The setup includes a **Lambda Function**, **IAM Role & Policies**, and an optional **API Gateway** integration to trigger the function via HTTP requests.

---

## 🚀 Features

* Deploys a **serverless AWS Lambda function** using Terraform.
* **IAM role** and **permissions** managed automatically.
* **Environment variables** for configuration.
* Optional **API Gateway** trigger for REST endpoints.
* Easily extendable for multiple environments (dev, stage, prod).

---

## 📝 Example Lambda Function (`lambda_function.py`)

Here’s a simple Python Lambda function that returns a greeting:

```python
import json

def lambda_handler(event, context):
    name = event.get("queryStringParameters", {}).get("name", "World")
    return {
        "statusCode": 200,
        "body": json.dumps({"message": f"Hello, {name}! Welcome to AWS Lambda 🚀"})
    }
```

---

## ⚙️ Terraform Code

### **1. IAM Role & Policy**

```hcl
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

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
resource "aws_lambda_function" "hello_lambda" {
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

### **3. API Gateway (Optional)**

```hcl
resource "aws_apigatewayv2_api" "http_api" {
  name          = "lambda-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.hello_lambda.invoke_arn
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
  function_name = aws_lambda_function.hello_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
```

---

### **4. Variables (`variables.tf`)**

```hcl
variable "lambda_function_name" {
  default = "hello-lambda"
}

variable "environment" {
  default = "dev"
}
```
---

## 📊 Outputs

```hcl
output "lambda_function_arn" {
  value = aws_lambda_function.hello_lambda.arn
}

output "api_endpoint" {
  value = aws_apigatewayv2_stage.default_stage.invoke_url
}
```

Example output:

```bash
lambda_function_arn = arn:aws:lambda:us-east-1:123456789012:function:hello-lambda
api_endpoint        = https://abcd1234.execute-api.us-east-1.amazonaws.com/hello
```
---

## 📚 References

* [Terraform AWS Lambda Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)
* [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
* [API Gateway + Lambda Integration](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html)
