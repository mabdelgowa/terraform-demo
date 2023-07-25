

resource "aws_subnet" "nginx-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name: "${var.cidr_blocks[1].name}-subnet"
  }
}

resource "aws_internet_gateway" "nginx-gateway" {
  vpc_id = var.vpc_id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}
resource "aws_route_table" "nginx-route-table" {

  vpc_id         = var.vpc_id
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