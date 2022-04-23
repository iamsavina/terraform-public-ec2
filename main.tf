resource "aws_vpc" "terraform_dev_vpc" {
  cidr_block           = "10.254.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name : "terraform_dev"
  }

}

resource "aws_internet_gateway" "terraform_gw" {
  vpc_id = aws_vpc.terraform_dev_vpc.id

  tags = {
    Name = "terraform_gw"
  }
}

resource "aws_route_table" "terraform_route_table" {
  vpc_id = aws_vpc.terraform_dev_vpc.id

  tags = {
    Name = "terraform_route_table"
  }
}

resource "aws_route" "terraform_route" {
  route_table_id         = aws_route_table.terraform_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terraform_gw.id
}

resource "aws_subnet" "terraform_dev_subnet" {
  vpc_id                  = aws_vpc.terraform_dev_vpc.id
  cidr_block              = "10.254.0.0/16"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform_public_subnet"
  }
}

resource "aws_route_table_association" "terraform_route_assoc" {
  subnet_id      = aws_subnet.terraform_dev_subnet.id
  route_table_id = aws_route_table.terraform_route_table.id
}


resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "Allow only ssh"
  vpc_id      = aws_vpc.terraform_dev_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform_rules"
  }
}

resource "aws_key_pair" "terraform_keypair" {
  key_name   = "terraform-key"
  public_key = file("/home/savi/.ssh/terraform-key.pub")
}


resource "aws_instance" "terraform_ec2" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.ubuntu_server.id
  key_name               = aws_key_pair.terraform_keypair.id
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]
  subnet_id              = aws_subnet.terraform_dev_subnet.id
  user_data              = file("userdata.tpl")

  tags = {
    Name = "Terraform EC2"
  }

  root_block_device {
    volume_size = 8 # default
  }

}