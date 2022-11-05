#!/bin/bash

DISTRO_CODENAME=$(lsb_release -cs)
RABBITMQ_VERSION=$(sudo rabbitmqctl version)
RABBITMQ_MAJOR=$(echo "$RABBITMQ_VERSION" | cut -d. -f1)
RABBITMQ_MINOR=$(echo "$RABBITMQ_VERSION" | cut -d. -f2)

if [ "3" = "$RABBITMQ_MAJOR" ] && [ "$RABBITMQ_MINOR" -ge "8" ]; then
  echo "RabbitMQ detected!"
  echo "Version: $RABBITMQ_VERSION"
  echo "Skipping setup..."
  exit
fi

echo "RabbitMQ not found, installing..."
sudo apt-get install curl gnupg apt-transport-https -y

## Team RabbitMQ's main signing key
curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg >/dev/null
## Launchpad PPA that provides modern Erlang releases
curl -1sLf "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf77f1eda57ebb1cc" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg >/dev/null
## PackageCloud RabbitMQ repository
curl -1sLf "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/io.packagecloud.rabbitmq.gpg >/dev/null

## Add apt repositories maintained by Team RabbitMQ
sudo tee rabbitmq.list <<EOF
deb [signed-by=/usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg] http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu $DISTRO_CODENAME main
deb-src [signed-by=/usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg] http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu $DISTRO_CODENAME main
deb [signed-by=/usr/share/keyrings/io.packagecloud.rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ $DISTRO_CODENAME main
deb-src [signed-by=/usr/share/keyrings/io.packagecloud.rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ $DISTRO_CODENAME main
EOF

## Update package indices
sudo apt-get update -y

## Install Erlang packages
sudo apt-get install -y erlang-base \
  erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
  erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
  erlang-runtime-tools erlang-snmp erlang-ssl \
  erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl

## Install rabbitmq-server and its dependencies
sudo apt-get install rabbitmq-server -y --fix-missing

sudo rabbitmq-plugins enable rabbitmq_management
sudo rabbitmqctl add_vhost hyperion
sudo rabbitmqctl add_user hyperion_user hyperion_password
sudo rabbitmqctl set_user_tags hyperion_user administrator
sudo rabbitmqctl set_permissions -p hyperion hyperion_user ".*" ".*" ".*"
