resource "aws_vpc" "main" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id 
    availability_zone = var.availability_zones[count.index]
    cidr_block = var.public_subnet_cidrs[count.index]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id 
    availability_zone = var.availability_zones[count.index]
    cidr_block = var.private_subnet_cidrs[count.index]
    map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id 
}

resource "aws_eip" "eip"{
    count = length(var.public_subnet_cidrs)
}

resource "aws_nat_gateway" "ngw" {
    count = length(var.public_subnet_cidrs)
    allocation_id = aws_eip.eip[count.index].id
    subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table" "public" {
    vpc_id  = aws_vpc.main.id 
    route{
        gateway_id = aws_internet_gateway.igw.id
        cidr_block = "0.0.0.0/0"
    }
}

resource "aws_route_table" "private" {
    vpc_id  = aws_vpc.main.id 
     count = length(var.public_subnet_cidrs)
    route{
        nat_gateway_id = aws_nat_gateway.ngw[count.index].id
        cidr_block = "0.0.0.0/0"
    }
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}
