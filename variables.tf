variable "aws_region" {
  description = "AWS regione where launch servers"
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "aws profile"
  default     = "default"
}

variable "aws_amis" {
  default = {
    eu-west-1 = "ami-035966e8adab4aaad"
    us-west-2 = "ami-0d1cd67c26f5fca19"
    us-east-1 = "ami-07ebfd5b3428b6f4d"
  }
}

variable "elk_instance_type" {
  default = "m4.large"
}

variable "aws_public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/elk-terraform.pub
DESCRIPTION

}

variable "aws_key_name" {
  description = "Name of the AWS key pair"
}

variable "elasticsearch_data_dir" {
  default = "/opt/elasticsearch/data"
}

variable "elasticsearch_cluster" {
  description = "Name of the elasticsearch cluster"
  default     = "elk_cluster"
}

