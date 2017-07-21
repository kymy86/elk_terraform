output "elk_vpc_id" {
    value = "${aws_vpc.elk_vpc.id}"
}

output "elk_private_subnet_id" {
    value = "${aws_subnet.private_subnet.id}"
}

output "elk_public_subnet_id" {
    value = "${aws_subnet.public_subnet.id}"
}

output "elk_private_subnet_cidr" {
    value = "${aws_subnet.private_subnet.cidr_block}"
}

output "elk_public_subnet_cidr" {
    value = "${aws_subnet.public_subnet.cidr_block}"
}