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

data "template_file" "init_elasticsearch" {
  template = file("./user_data/init_esearch.tpl")

  vars = {
    elasticsearch_cluster  = var.elasticsearch_cluster
    elasticsearch_data_dir = var.elasticsearch_data_dir
  }
}

resource "aws_instance" "elasticsearch" {
  ami           = var.aws_amis[var.aws_region]
  instance_type = var.elk_instance_type
  key_name      = var.aws_key_name
  security_groups      = [module.security.elasticsearch_sc_id]
  subnet_id            = module.network.elk_private_subnet_id
  iam_instance_profile = module.iam.es_iam_id

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "io1"
    volume_size = "20"
    iops        = "500"
  }

  user_data = data.template_file.init_elasticsearch.rendered

  tags = {
    Name = "Elasticsearch instance"
  }
}

data "template_file" "init_logstash" {
  template = file("./user_data/init_logstash.tpl")

  vars = {
    elasticsearch_host = aws_instance.elasticsearch.private_ip
  }
}

resource "aws_instance" "logstash" {
  ami           = var.aws_amis[var.aws_region]
  instance_type = var.elk_instance_type
  key_name      = var.aws_key_name
  security_groups = [module.security.esearch_sc_id]
  subnet_id       = module.network.elk_private_subnet_id

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "io1"
    volume_size = "20"
    iops        = "500"
  }

  user_data = data.template_file.init_logstash.rendered

  tags = {
    Name = "Logstash instance"
  }
}

data "template_file" "init_kibana" {
  template = file("./user_data/init_kibana.tpl")

  vars = {
    elasticsearch_host = aws_instance.elasticsearch.private_ip
  }
}

resource "aws_instance" "kibana" {
  ami           = var.aws_amis[var.aws_region]
  instance_type = var.elk_instance_type
  key_name      = var.aws_key_name
  security_groups = [module.security.elk_sc_id]
  subnet_id       = module.network.elk_public_subnet_id

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_type = "io1"
    volume_size = "10"
    iops        = "500"
  }

  user_data = data.template_file.init_kibana.rendered

  tags = {
    Name = "Kibana instance"
  }
}

