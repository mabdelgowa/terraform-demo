provider "aws"{
  region = "us-east-1"
}

variable "cidr_blocks" {
  description = "subnet cidr block"
  type = list(object({
    cidr_block = string
    name = string
  }))
}

variable "my_ip" {}

variable "instance_type" {}

variable "env_prefix" {}

resource "aws_vpc" "nginx-vpc"{
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: "${var.cidr_blocks[0].name}-vpc",
  }
}

resource "aws_subnet" "nginx-subnet-1" {
  vpc_id = aws_vpc.nginx-vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name: "${var.cidr_blocks[1].name}-subnet"
  }
}

resource "aws_internet_gateway" "nginx-gateway" {
  vpc_id = aws_vpc.nginx-vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}
resource "aws_route_table" "nginx-route-table" {

  vpc_id         = aws_vpc.nginx-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx-gateway.id
  }
  tags = {
    Name: "${var.env_prefix}-rtb"
  }
}

resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id = aws_subnet.nginx-subnet-1.id
  route_table_id = aws_route_table.nginx-route-table.id
}

resource "aws_security_group" "nginx-sg" {
  name = "nginx-sg"
  vpc_id = aws_vpc.nginx-vpc.id
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = var.my_ip
  }
  ingress {
    from_port = 8080
    protocol  = "tcp"
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "nginx-server" {
  availability_zone = "us-east-1a"
  ami = "ami-05548f9cecf47b442"
  instance_type = var.instance_type
  subnet_id = aws_subnet.nginx-subnet-1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  associate_public_ip_address = true
  key_name = "new1"
  user_data = file("entry-script.sh")
  tags = {
    Name = "${var.env_prefix}-server"
  }
}


