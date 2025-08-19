## To apply the changes directly instead changing the tf file

```
terraform  apply —auto-approve —var instance_type=t2.micro —var subentid=subnet-0a58e322b90bc6791
```
Or we can create a var file production.tfvars and pass this while executing terraform  apply —auto-approve —var-file=production.tfvar
