# Banrimkwae.com - WordPress Docker Setup

This is a Docker-based WordPress hosting environment using Nginx, PHP-FPM, and MariaDB.

## Architecture

The setup consists of three main services:
- **Nginx**: Web server and reverse proxy
- **PHP-FPM**: PHP 8.3 with WordPress-optimized extensions
- **MariaDB**: Database server

## Prerequisites

- Docker and Docker Compose installed
- Domain configured to point to your server (optional for local development)

## Installation

### 1. Environment Configuration

Create a `.env` file in the project root with your database credentials:

```bash
DATABASENAME=your_database_name
DATABASEUSER=your_database_user
DATABASEPASS=your_database_password
```

### 2. Database Setup

If you have an existing database dump, place the SQL file in the `database/` folder. It will be automatically imported during the first container startup.

### 3. WordPress Files

Place your WordPress installation files in the `www/` folder. The current setup appears to have WordPress already configured.

### 4. Nginx Configuration

The Nginx configuration is already set up for the domain `domain.com` with Cloudflare integration. If you need to modify the domain or SSL settings, edit `nginx/nginx.conf`.

### 5. Deploy

Start the services:

```bash
docker compose up -d
```

## Services

### Nginx
- **Ports**: 80 (HTTP), 443 (HTTPS ready)
- **Configuration**: `nginx/nginx.conf`
- **Features**: Cloudflare IP trust, 64MB upload limit, WordPress optimizations

### PHP-FPM
- **Version**: PHP 8.3
- **Extensions**: GD, PDO MySQL, MySQLi, Zip, XML, Mbstring, cURL, OPcache
- **Configuration**: Custom PHP settings via `php.ini`

### MariaDB
- **Version**: Latest
- **Data**: Persistent storage via Docker volume `brk_data`
- **Initialization**: Automatic import from `database/` folder

## File Structure

```
.
├── docker-compose.yml          # Main Docker Compose configuration
├── dockerfile                  # Custom PHP-FPM image
├── README.md                  # This file
├── database/                  # Database initialization files
│   └── database.sql          # SQL dump (if available)
├── nginx/                    # Nginx configuration
│   └── nginx.conf
└── www/                      # WordPress installation
    ├── index.php
    ├── wp-config.php
    └── ...
```

## Management Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs -f [service_name]

# Access containers
docker compose exec nginx bash
docker compose exec php bash
docker compose exec db bash

# Backup database
docker compose exec db mysqldump -u root -prootpassword your_database_name > backup.sql

# Restart specific service
docker compose restart [service_name]
```

## Troubleshooting

### File Permissions
If you encounter permission issues, the PHP container automatically sets proper ownership:
```bash
chown -R www-data:www-data /var/www/html
```

### Database Connection
Verify database credentials in your `.env` file match those in `wp-config.php`.

### Logs
Check container logs for issues:
```bash
docker compose logs php
docker compose logs nginx
docker compose logs db
```

## Security Notes

- Default MariaDB root password is set to `rootpassword` - change this in production
- Consider setting up SSL certificates for HTTPS in production
- The setup is optimized for Cloudflare but can work with direct connections
