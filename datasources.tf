data "aws_ami" "ubuntu_server" {
  most_recent = true
  owners      = ["099720109477"] # EC2 > AMIs > Image owner

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

}