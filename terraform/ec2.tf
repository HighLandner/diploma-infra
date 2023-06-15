data "aws_ami" "ubuntu_20_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "web" {
  ami              = data.aws_ami.ubuntu_20_04.id
  instance_type    = "t2.micro"
  subnet_id        = aws_subnet.public.id
  private_ip       = "10.0.0.1"
  user_data_base64 = "${file("user-data/web-user-data.sh")}"

  tags = {
    Name = "web"
  }
}

resource "aws_instance" "jenkins" {
  ami              = data.aws_ami.ubuntu_20_04.id
  instance_type    = "t2.micro"
  subnet_id        = aws_subnet.public.id
  private_ip       = "10.0.4.1"
  user_data_base64 = "${file("user-data/jenkins-user-data.sh")}"

  tags = {
    Name = "jenkins"
  }
}

resource "aws_instance" "nexus" {
  ami              = data.aws_ami.ubuntu_20_04.id
  instance_type    = "t2.micro"
  subnet_id        = aws_subnet.public.id
  private_ip       = "10.0.4.2"
  user_data_base64 = "${file("user-data/nexus-user-data.sh")}"

  tags = {
    Name = "nexus"
  }
}
