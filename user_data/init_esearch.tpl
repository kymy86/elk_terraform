#!/usr/bin/env bash

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade
sudo apt-get install openjdk-8-jre -y
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get update
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sudo apt-get update
sudo apt-get install elasticsearch
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2 -s

cat << EOF >/etc/elasticsearch/elasticsearch.yml

cluster.name: ${elasticsearch_cluster}
network.host: _ec2:privateIpv4_
EOF

sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10