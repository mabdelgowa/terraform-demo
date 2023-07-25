resource "aws_security_group" "nginx-sg" {
  name = "nginx-sg"
  vpc_id = var.vpc_id
  ingress {
    //to allow ssh connection on EC2 instance
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = var.my_ip
  }
  ingress {
    //to be able to connect to the ngnix container
    from_port = 8080
    protocol  = "tcp"
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    //to allow the instance to connect to yum repo to install docker
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "nginx-server" {
  availability_zone = var.availability_zone
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  associate_public_ip_address = true
  key_name = var.key_name // this key was generated before and I generated a .ppk to ssh from putty
  user_data = file("entry-script.sh")
  tags = {
    Name = "${var.env_prefix}-server"
  }
}
