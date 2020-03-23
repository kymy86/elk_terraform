resource "aws_security_group" "elk_sc_default" {
    name = "elk_default_security_group"
    description = "Main security group for instances in public subnet"
    vpc_id = var.vpc_id

    ingress {
        from_port = 5601
        to_port = 5601
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ELK default security group"
    }
}

resource "aws_security_group" "elk_sc_esearch" {
    name = "elk_esearch_security_group"
    description = "Security group for Elasticsearch instance"
    vpc_id = var.vpc_id

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["${var.private_vpc_cidr}", "${var.public_vpc_cidr}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ELK default security group"
    }
}

resource "aws_security_group" "elasticsearch" {
    name = "elasticsearch_security_group"
    description = "Security group for elasticsearch cluster"
    vpc_id = var.vpc_id

    ingress {
        from_port = 9200
        to_port = 9400
        protocol = "tcp"
        cidr_blocks = ["${var.private_vpc_cidr}", "${var.public_vpc_cidr}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Elasticsearch default security groups"
    }
}