# DevOps Project: AWS Infrastructure Provisioning

This project focuses on automating the provisioning of AWS infrastructure using Terraform. It sets up a VPC, internet gateway, route table, subnet, security group, network interface, and an EC2 instance running an Apache web server.

## Features

- Automated provisioning of AWS infrastructure
- VPC creation with a specified CIDR block
- Internet gateway creation and association with the VPC
- Custom route table setup for IPv4 and IPv6 traffic
- Subnet creation with a specific CIDR block and availability zone
- Security group configuration to allow web traffic (HTTP, HTTPS, SSH)
- Network interface creation and assignment of a private IP
- Elastic IP association with the network interface
- EC2 instance provisioning with Ubuntu, Apache installation, and web server deployment
- Output of the instance's private IP, public IP, and instance ID

## Technologies Used

- Terraform
- Amazon Web Services (AWS)
- Ubuntu
- Apache

## Setup Instructions

To provision the infrastructure on AWS, follow these steps:

1. Clone the repository:

   ```
   git clone https://github.com/mohamedassaker/Terraform-AWS-EC2-Ubuntu-Server.git
   ```

2. Navigate to the project directory:

   ```
   cd <repository>
   ```

3. Install Terraform on your local machine.

4. Create an AWS IAM user with the necessary permissions and obtain the access key and secret key.

5. Open the `main.tf` file and replace the empty `access_key` and `secret_key` fields in the AWS provider block with your AWS IAM user credentials.

6. Customize the `subnet_prefix` variable in the `terraform.tfvars` file according to your desired CIDR block for the VPC subnet.

7. Initialize the Terraform project:

   ```
   terraform init
   ```

8. Preview the changes that will be applied:

   ```
   terraform plan
   ```

9. Apply the changes and provision the infrastructure:

   ```
   terraform apply
   ```

   Enter `yes` when prompted to confirm the provisioning.

10. Once the provisioning is complete, you will see the outputs containing the private IP, public IP, and instance ID of the EC2 instance.

11. Access the web server by opening the public IP in a web browser.

## Customization

Feel free to customize the Terraform code and configuration files to match your specific requirements. You can modify the CIDR block, availability zone, instance type, user data script, and other parameters according to your needs.

## Cleanup

To clean up and destroy the provisioned infrastructure, run the following command:

```
terraform destroy
```

Enter `yes` when prompted to confirm the destruction.

## Note

- Make sure to keep your AWS IAM user credentials and access keys secure.
