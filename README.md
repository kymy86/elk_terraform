# Terraform script to build ELK stack in AWS ![version][version-badge]

[version-badge]: https://img.shields.io/badge/version-0.0.2-blue.svg

With this Terraform script, you can set up an [ELK] stack.

**N.B.** Logstash is configured with the heartbeat plugin for testing purposes only.

**N.B.2** For using this stack in a production environment, you must use a cluster of Elasticsearch instances.

## Set-up

You must setup the following variables:

- **aws_profile**: name of AWS profile. If nothing is setted, the  `default` profile is taken.
- **aws_key_name**: name of the AWS private key.
- **aws_public_key_path**: absolute path of the AWS public key.



[ELK]: https://www.elastic.co/