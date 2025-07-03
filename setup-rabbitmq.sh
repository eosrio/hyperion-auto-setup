#!/bin/bash

DISTRO_CODENAME=$(lsb_release -cs)

install_rabbitmq() {
  echo "Installing RabbitMQ..."

  # Check if the distribution is supported
  if [ "$DISTRO_CODENAME" != "noble" ] && [ "$DISTRO_CODENAME" != "jammy" ]; then
    echo "Error: RabbitMQ setup only supports Ubuntu 24.04 (noble) or 22.04 (jammy)"
    echo "Current distribution: $DISTRO_CODENAME"
    exit 1
  fi

  sudo apt-get update

  sudo apt-get install curl gnupg apt-transport-https -y

  ## Team RabbitMQ's main signing key
  curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg >/dev/null
  ## Community mirror of Cloudsmith: modern Erlang repository
  curl -1sLf https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-erlang.E495BB49CC4BBE5B.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg >/dev/null
  ## Community mirror of Cloudsmith: RabbitMQ repository
  curl -1sLf https://github.com/rabbitmq/signing-keys/releases/download/3.0/cloudsmith.rabbitmq-server.9F4587F226208342.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/rabbitmq.9F4587F226208342.gpg >/dev/null

  ## Add apt repositories maintained by Team RabbitMQ
  sudo tee /etc/apt/sources.list.d/rabbitmq.list <<EOF
## Provides modern Erlang/OTP releases
##
deb [arch=amd64 signed-by=/usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg] https://ppa1.rabbitmq.com/rabbitmq/rabbitmq-erlang/deb/ubuntu $DISTRO_CODENAME main
deb-src [arch=amd64 signed-by=/usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg] https://ppa1.rabbitmq.com/rabbitmq/rabbitmq-erlang/deb/ubuntu $DISTRO_CODENAME main

# another mirror for redundancy
deb [arch=amd64 signed-by=/usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg] https://ppa2.rabbitmq.com/rabbitmq/rabbitmq-erlang/deb/ubuntu $DISTRO_CODENAME main
deb-src [arch=amd64 signed-by=/usr/share/keyrings/rabbitmq.E495BB49CC4BBE5B.gpg] https://ppa2.rabbitmq.com/rabbitmq/rabbitmq-erlang/deb/ubuntu $DISTRO_CODENAME main

## Provides RabbitMQ
##
deb [arch=amd64 signed-by=/usr/share/keyrings/rabbitmq.9F4587F226208342.gpg] https://ppa1.rabbitmq.com/rabbitmq/rabbitmq-server/deb/ubuntu $DISTRO_CODENAME main
deb-src [arch=amd64 signed-by=/usr/share/keyrings/rabbitmq.9F4587F226208342.gpg] https://ppa1.rabbitmq.com/rabbitmq/rabbitmq-server/deb/ubuntu $DISTRO_CODENAME main

# another mirror for redundancy
deb [arch=amd64 signed-by=/usr/share/keyrings/rabbitmq.9F4587F226208342.gpg] https://ppa2.rabbitmq.com/rabbitmq/rabbitmq-server/deb/ubuntu $DISTRO_CODENAME main
deb-src [arch=amd64 signed-by=/usr/share/keyrings/rabbitmq.9F4587F226208342.gpg] https://ppa2.rabbitmq.com/rabbitmq/rabbitmq-server/deb/ubuntu $DISTRO_CODENAME main
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
  if ! sudo rabbitmqctl list_vhosts | grep -q "hyperion"; then
    sudo rabbitmqctl add_vhost hyperion
  fi
  if ! sudo rabbitmqctl list_users | grep -q "hyperion_user"; then
    sudo rabbitmqctl add_user hyperion_user hyperion_password
  fi
  sudo rabbitmqctl set_user_tags hyperion_user administrator
  sudo rabbitmqctl set_permissions -p hyperion hyperion_user ".*" ".*" ".*"
}

if command -v rabbitmqctl &>/dev/null; then
  RABBITMQ_VERSION=$(sudo rabbitmqctl version)
  RABBITMQ_MAJOR=$(echo "$RABBITMQ_VERSION" | cut -d. -f1)

  if [ "$RABBITMQ_MAJOR" -ge "4" ]; then
    echo "RabbitMQ detected!"
    echo "Version: $RABBITMQ_VERSION"
    echo "Skipping setup..."
  else
    echo "RabbitMQ version mismatch, installing..."
    install_rabbitmq
  fi
else
  echo "RabbitMQ not found, installing..."
  install_rabbitmq
fi
