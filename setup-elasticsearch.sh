#!/bin/bash

function checkElasticsearchVersion() {
 ES_HOST="https://localhost:9200"
 ES_CERT_PATH="/etc/elasticsearch/certs/http_ca.crt"
 ES_VERSION=$(sudo curl -Ss --cacert $ES_CERT_PATH -u elastic:"$(cat elastic.pass)" $ES_HOST | jq -r '.version.number')
 ES_MAJOR=$(echo "$ES_VERSION" | cut -d. -f1)
 echo "$ES_VERSION" > .elasticsearch.version
}

function installElasticsearch() {
  echo "Installing Elasticsearch v9..."
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
  sudo apt-get install apt-transport-https
  echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/9.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-9.x.list
  sudo apt-get update && sudo apt-get install elasticsearch
  sudo systemctl daemon-reload
  sudo systemctl enable elasticsearch.service
  sudo systemctl start elasticsearch.service
  # reset elastic password
  echo "Resetting elastic user password..."
  sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -a -s -b | tee elastic.pass
  checkElasticsearchVersion
  echo "Elasticsearch Ready! - Version: $ES_VERSION"
}

if command -v elasticsearch &> /dev/null
then
  checkElasticsearchVersion
  if [ "9" = "$ES_MAJOR" ]; then
    echo "Elasticsearch detected!"
    echo "Version: $ES_VERSION"
    echo "Skipping setup..."
  else
    echo "Elasticsearch version mismatch, installing v9..."
    installElasticsearch
  fi
else
  echo "Elasticsearch not found, installing..."
  installElasticsearch
fi
