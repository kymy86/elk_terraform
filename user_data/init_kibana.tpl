#!/usr/bin/env bash

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get update
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list

#Configure kibana

cat << EOF >/tmp/kibana.yml
port: 5601
server.host: "0.0.0.0"
elasticsearch_url: "http://${elasticsearch_host}:9200"
elasticsearch_preserve_host: true
kibana_index: ".kibana"
default_app_id: "discover"
request_timeout: 300000
shard_timeout: 0
EOF

sudo apt-get update && sudo apt-get install kibana

sudo mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml.orig
sudo mv /tmp/kibana.yml /etc/kibana/kibana.yml

sudo service kibana start