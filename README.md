# quick-ec2-tf
Quick TF EC2 used locally by myself to spinup a quick ec2 instance for testing

## Quickstart
```bash
doormat login
eval $(doormat aws --account $(cat account.txt))
terraform init
```

```bash
terraform apply
```