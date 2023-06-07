resource "aws_vpc" "main" {
  cidr_block       = var.vpc_main_cidr # 10.0.0.0/16
  instance_tenancy = "default"

  tags = {
    Name  = "main"
    Stage = "Diploma"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 2, 0) # 10.0.0.0/30
  availability_zone = var.availability_zone

  tags = {
    Name  = "public-diploma"
    State = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 2, 4) # 10.0.4.0/30
  availability_zone = var.availability_zone

  tags = {
    Name  = "private-diploma"
    State = "private"
  }
}
