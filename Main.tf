provider "aws"{
  region = "us-east-1"
}

resource "aws_vpc" "nginx-vpc"{
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: "${var.cidr_blocks[0].name}-vpc",
  }
}

module "mynginx-subnet" {
  source = "./modules/subnet"
  cidr_blocks = var.cidr_blocks
  availability_zone = "us-east-1a"
  env_prefix = "nginx-server"
  vpc_id = aws_vpc.nginx-vpc.id
  default_route_table_id = aws_vpc.nginx-vpc.default_route_table_id
}

module "mynginx-webserver" {
  source = "./modules/webserver"
  my_ip = var.my_ip
  instance_type = var.instance_type
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.nginx-vpc.id
  subnet_id = module.mynginx-subnet.subnet
  key_name = var.key_name
  ami = var.ami
  availability_zone = var.availability_zone
}

