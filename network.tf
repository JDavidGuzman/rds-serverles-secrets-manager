resource "aws_vpc" "main" {

  cidr_block = "10.0.0.0/16"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-vpc" })
  )
}

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-igw" })
  )
}

resource "aws_subnet" "bastion_subnet" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bastion" })
  )
}

resource "aws_subnet" "rds_subnet" {
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = count.index == 0 ? "${data.aws_region.current.name}a" : "${data.aws_region.current.name}b"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-aurora-${count.index}" })
  )
}

resource "aws_route_table" "bastion_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bastion-rt" })
  )
}

resource "aws_route_table_association" "bastion_rt_association" {

  subnet_id      = aws_subnet.bastion_subnet.id
  route_table_id = aws_route_table.bastion_rt.id
}