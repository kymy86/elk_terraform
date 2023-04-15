provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_key_pair" "elk_auth" {
  key_name   = var.aws_key_name
  public_key = file(var.aws_public_key_path)
}

module "iam" {
  source = "./iam"
}

module "network" {
  source = "./network"
}

module "security" {
  source           = "./security"
  vpc_id           = module.network.elk_vpc_id
  private_vpc_cidr = module.network.elk_private_subnet_cidr
  public_vpc_cidr  = module.network.elk_public_subnet_cidr
}

data "aws_ami" "aws_amis" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "elasticsearch" {
  ami                  = data.aws_ami.aws_amis.id
  instance_type        = var.elk_instance_type
  key_name             = var.aws_key_name
  security_groups      = [module.security.elasticsearch_sc_id]
  subnet_id            = module.network.elk_private_subnet_id
  iam_instance_profile = module.iam.es_iam_id

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "io2"
    volume_size = "20"
    iops        = "500"
  }

  user_data = templatefile(
    "${path.module}/user_data/init_esearch.tpl",
    {
      elasticsearch_cluster  = var.elasticsearch_cluster
      elasticsearch_data_dir = var.elasticsearch_data_dir
    }
  )

  tags = {
    Name = "Elasticsearch instance"
  }
}

resource "aws_instance" "logstash" {
  ami             = data.aws_ami.aws_amis.id
  instance_type   = var.elk_instance_type
  key_name        = var.aws_key_name
  security_groups = [module.security.esearch_sc_id]
  subnet_id       = module.network.elk_private_subnet_id

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "io2"
    volume_size = "20"
    iops        = "500"
  }

  user_data = templatefile(
    "${path.module}/user_data/init_logstash.tpl",
    {
      elasticsearch_host = aws_instance.elasticsearch.private_ip
    }
  )

  tags = {
    Name = "Logstash instance"
  }
}

resource "aws_instance" "kibana" {
  ami             = data.aws_ami.aws_amis.id
  instance_type   = var.elk_instance_type
  key_name        = var.aws_key_name
  security_groups = [module.security.elk_sc_id]
  subnet_id       = module.network.elk_public_subnet_id

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "io1"
    volume_size = "10"
    iops        = "500"
  }

  user_data = templatefile(
    "${path.module}/user_data/init_kibana.tpl",
    {
      elasticsearch_host = aws_instance.elasticsearch.private_ip
    }
  )

  tags = {
    Name = "Kibana instance"
  }
}

