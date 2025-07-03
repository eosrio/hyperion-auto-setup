# Hyperion Auto Setup

This repository provides an automated installation script for [Hyperion History API](https://github.com/eosrio/hyperion-history-api), a scalable full history solution for EOSIO-based blockchains.

## What is Hyperion?

Hyperion is a full history solution that provides fast access to indexed blockchain data on EOSIO-based networks. It offers:
- High-performance API endpoints for historical data
- Real-time streaming capabilities
- Advanced search and filtering options
- Scalable architecture for enterprise deployments

## System Requirements

- **Operating System**: Ubuntu 22.04 LTS (jammy) or Ubuntu 24.04 LTS (noble)
- **Architecture**: amd64 (x86_64)
- **Memory**: Minimum 8GB RAM (16GB+ recommended)
- **Storage**: At least 100GB free space (varies based on blockchain size)
- **Network**: Stable internet connection for downloading packages

## Quick Installation

```shell
mkdir -p ~/.hyperion-installer && cd ~/.hyperion-installer
wget -qO- https://github.com/eosrio/hyperion-auto-setup/raw/main/install.tar.gz | tar -xvz
./install.sh
```

## What Gets Installed

The installation script automatically sets up the following components:

### 1. System Tools (`setup-tools.sh`)
- **jq**: JSON processor for configuration parsing
- **curl**: HTTP client for downloading packages
- **git**: Version control system
- **unzip**: Archive extraction utility
- **gnupg**: GPG tools for package verification
- **lsb-release**: Linux distribution information
- **net-tools**: Network utilities
- **apt-transport-https**: HTTPS transport for APT

### 2. Node.js Environment (`setup-nodejs.sh`)
- **FNM (Fast Node Manager)**: Node.js version manager
- **Node.js 24.x**: Latest LTS version (or 22.16+ if compatible)
- **npm**: Node.js package manager
- Configures shell environment for FNM

### 3. Process Manager (`setup-pm2.sh`)
- **PM2**: Production process manager for Node.js applications
- Configures PM2 startup service for automatic application restart
- Sets up system-level PM2 daemon

### 4. Database Systems

#### Elasticsearch (`setup-elasticsearch.sh`)
- **Elasticsearch 9.x**: Search and analytics engine (accepts v8/v9)
- Configures security settings and certificates
- Generates elastic user password (saved to `elastic.pass`)
- Enables and starts Elasticsearch service

#### MongoDB (`setup-mongodb.sh`)
- **MongoDB 8.x**: Document database for configuration and metadata
- Adds official MongoDB APT repository
- Enables and starts MongoDB service
- Creates version tracking file

#### Redis (`setup-redis.sh`)
- **Redis 8.x**: In-memory data store for caching (accepts v7+)
- Adds official Redis APT repository
- Enables and starts Redis service
- Creates version tracking file

### 5. Message Queue (`setup-rabbitmq.sh`)
- **RabbitMQ**: Message broker for distributed processing
- **Erlang**: Required runtime environment
- Enables RabbitMQ management plugin
- Creates dedicated vhost and user:
  - VHost: `hyperion`
  - User: `hyperion_user`
  - Password: `hyperion_password`
- Configures proper permissions and administrator access

### 6. Hyperion History API (`setup-hyperion.sh`)
- Clones the official Hyperion repository to `~/hyperion`
- Installs Node.js dependencies via npm
- Ready for configuration and deployment

## Installation Process

The installer follows this sequence:

1. **System Check**: Verifies Ubuntu 22.04 or 24.04
2. **Tool Installation**: Installs required system utilities
3. **Node.js Setup**: Installs and configures Node.js environment
4. **Service Installation**: Sets up databases and message queue
5. **Hyperion Clone**: Downloads and prepares Hyperion API

Each component is checked before installation - if already present with compatible versions, the installation is skipped.

## Post-Installation Steps

After successful installation:

1. **Navigate to Hyperion directory**:
   ```shell
   cd ~/hyperion
   ```

2. **Configure Hyperion**: Edit configuration files in the `examples` directory

3. **Start Services**: Ensure all services are running:
   ```shell
   sudo systemctl status elasticsearch
   sudo systemctl status mongod
   sudo systemctl status redis-server
   sudo systemctl status rabbitmq-server
   ```

4. **Access Credentials**:
   - Elasticsearch password: stored in `~/hyperion-installer/elastic.pass`
   - RabbitMQ: `hyperion_user` / `hyperion_password`

## Troubleshooting

### Common Issues

- **Unsupported OS**: Only Ubuntu 22.04 and 24.04 are supported
- **Insufficient Permissions**: Ensure your user has sudo access
- **Network Issues**: Check internet connectivity for package downloads
- **Port Conflicts**: Default ports used:
  - Elasticsearch: 9200, 9300
  - MongoDB: 27017
  - Redis: 6379
  - RabbitMQ: 5672, 15672

### Logs and Diagnostics

- Service logs: `sudo journalctl -u <service-name>`
- Elasticsearch logs: `/var/log/elasticsearch/`
- MongoDB logs: `/var/log/mongodb/`
- RabbitMQ logs: `/var/log/rabbitmq/`

## Removal

To uninstall components, use the provided removal scripts:

```shell
./remove.sh  # Removes all components
```

Or remove individual components:
- `./remove-hyperion.sh`
- `./remove-elasticsearch.sh`
- `./remove-mongodb.sh`
- `./remove-redis.sh`
- `./remove-rabbitmq.sh`
- `./remove-nodejs.sh`
- `./remove-pm2.sh`
- `./remove-tools.sh`

## Support

For issues related to:
- **Installation Script**: Open an issue in this repository
- **Hyperion Configuration**: Visit the [Hyperion History API repository](https://github.com/eosrio/hyperion-history-api)
- **EOSIO Integration**: Check the [EOSIO documentation](https://developers.eos.io/)

## License

This project is licensed under the same terms as the Hyperion History API.
