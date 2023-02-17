provider "aws" {
    region     = "us-east-1"
    access_key = ""
    secret_key = ""
}

# 1. Create a VPC
resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "production"
    }
}

# 2. Create an Internet Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.prod-vpc.id
}

# 3. Create Custom Route Table
resource "aws_route_table" "prod-route-table" {
    vpc_id = aws_vpc.prod-vpc.id
    
    # IPv4 Route
    route {
        # Set default route & send all traffic to the Internet Gateway
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    # IPv6 Route
    route {
        ipv6_cidr_block = "::/0"
        gateway_id      = aws_internet_gateway.gw.id
    }

    tags = {
        "Name" = "prod"
    }
}

# 4. Create a subnet
resource "aws_subnet" "subnet-1" {
    vpc_id            = aws_vpc.prod-vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        "Name" = "prod-subnet"
    }
}

# 5. Associate the subnet with the route table
resource "aws_route_table_association" "subnet-1-association" {
    subnet_id      = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create a security group to allow port 22, 80, 443
resource "aws_security_group" "allow-web" {
    name        = "allow_web_traffic"
    description = "Allow web traffic"
    vpc_id      = aws_vpc.prod-vpc.id

    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        # Allow traffic from anywhere
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        # Allow traffic from anywhere
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        # Allow traffic from anywhere
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        # Set protocol to -1 to allow all protocols
        protocol    = "-1"
        # Allow traffic from anywhere
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        "Name" = "allow_web"
    }
}

# 7. Create a network interface with ip of subnet-1
resource "aws_network_interface" "web-server-nic" {
    subnet_id       = aws_subnet.subnet-1.id
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.allow-web.id]
}

# 8. Assign an elastic IP to the network interface 
resource "aws_eip" "web-server-eip" {
    vpc                       = true
    network_interface         = aws_network_interface.web-server-nic.id
    associate_with_private_ip = "10.0.1.50"
    depends_on                = [aws_internet_gateway.gw]
}

# 9. Create EC2 Ubuntu server and install/enalbe apache2
resource "aws_instance" "web-server-instance" {
    ami                    = "ami-0c55b159cbfafe1f0"
    instance_type          = "t2.micro"
    availability_zone      = "us-east-1a" 
    key_name               = "main-key"
    subnet_id              = aws_subnet.subnet-1.id
    vpc_security_group_ids = [aws_security_group.allow-web.id]

    # Associate the elastic IP with the instance
    network_interface {
        network_interface_id = aws_network_interface.web-server-nic.id
        device_index         = 0
    }

    # Install apache2 and enable it
    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt-get install apache2 -y
        sudo systemctl enable apache2
        sudo systemctl start apache2
        sudo bash -c 'echo "web server deployed" > /var/www/html/index.html'
    EOF

    tags = {
        "Name" = "web-server"
    }
}