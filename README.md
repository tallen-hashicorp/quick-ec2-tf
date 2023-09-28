# quick-ec2-tf
Quick TF EC2 used locally by myself to spinup a quick ec2 instance for testing

## Prerequisite: Create an AWS Key Pair

Before you can use the Terraform configuration provided, you need to create an AWS Key Pair. This key pair will allow you to securely access your EC2 instances. Here's how to create one:

1. **Log in to the AWS Management Console:** Go to [AWS Console](https://aws.amazon.com/console/) and sign in to your AWS account.

2. **Navigate to EC2:** In the AWS Console, navigate to the EC2 service.

3. **Access Key Pairs:** In the EC2 dashboard, click on "Key Pairs" under the "Network & Security" section on the left-hand side.

4. **Create Key Pair:**
   - Click the "Create Key Pair" button.
   - Give your key pair a name (e.g., "my-key-pair").
   - Choose the key pair type (RSA is a common choice).
   - Click "Create Key Pair."

5. **Download the Private Key File:** After creating the key pair, you'll be prompted to download the private key file (e.g., "my-key-pair.pem"). Keep this file in a secure location because it's required to access your EC2 instances.

6. **Update Your Terraform Configuration:** In your Terraform configuration, specify the name of your key pair using the `key_name` variable.

```hcl
variable "key_name" {
  default = "tyler" # Replace with your key pair name
}
```

## Quickstart
```bash
doormat login
eval $(doormat aws --account $(cat account.txt))
terraform init
```

```bash
terraform apply
```

## Todo
* Add keypair creation, something like this may work
```hcl
resource "aws_key_pair" "example" {
  key_name   = "my-key-pair"  # Replace with your desired key pair name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}
```