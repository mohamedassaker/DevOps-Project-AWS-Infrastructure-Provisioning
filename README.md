# Terraform-AWS-EC2-Ubuntu-Server

This project creates AWS EC2 instance via Terraform. It allows HTTP, HTTPS, and SSH connection. The project is divided into these steps:

 1. Create a VPC

 2. Create an Internet Gateway

 3. Create Custom Route Table

 4. Create a subnet

 5. Associate the subnet with the route table

 6. Create a security group to allow port 22, 80, 443

 7. Create a network interface with ip of subnet-1

 8. Assign an elastic IP to the network interface 

 9. Create EC2 Ubuntu server and install/enalbe apache2
