resource "aws_vpc" "elk_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "ELK VPC"
    }
}

resource "aws_internet_gateway" "elk_gateway" {
    vpc_id = aws_vpc.elk_vpc.id
    tags = {
        Name = "ELK Gateway"
    }
}

resource "aws_route" "public_access" {
    route_table_id = aws_vpc.elk_vpc.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.elk_gateway.id
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.elk_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "Public subnet"
    }
}

resource "aws_eip" "nat_ip" {

}

resource "aws_nat_gateway" "elk_nat" {
    allocation_id = aws_eip.nat_ip.id
    subnet_id = aws_subnet.public_subnet.id
} 

resource "aws_route_table" "elk_route" {
    vpc_id = aws_vpc.elk_vpc.id
    tags = {
        Name = "Private route table"
    }
}

resource "aws_route" "private_access" {
    route_table_id = aws_route_table.elk_route.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.elk_nat.id
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.elk_vpc.id
    cidr_block = "10.0.2.0/24"
    tags = {
        Name = "Private subnet"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_vpc.elk_vpc.main_route_table_id
}

resource "aws_route_table_association" "private_subnet_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.elk_route.id
}