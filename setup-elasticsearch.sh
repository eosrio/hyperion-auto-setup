#!/bin/bash

# Check current ES installation

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

sudo apt-get install apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update && sudo apt-get install elasticsearch

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

# reset elastic password
echo "Resetting elastic user password..."
sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -a -s -b | tee elastic.pass

ES_VERSION=$(sudo curl -Ss --cacert /etc/elasticsearch/certs/http_ca.crt -u elastic:"$(cat elastic.pass)" https://localhost:9200 | jq -r '.version.number')

echo "Elasticsearch Ready! - Version: $ES_VERSION"

echo "$ES_VERSION" >.elasticsearch.version
