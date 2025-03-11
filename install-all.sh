#!/bin/bash

# Perbarui sistem
sudo apt update -y
sudo apt upgrade -y

# Instal Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y
sudo apt install docker-ce docker-compose-plugin -y

# Tambahkan user ke grup docker
sudo usermod -aG docker $USER

# Instal Docker Compose
sudo apt install docker-compose-plugin -y

# Instal SSH
sudo apt install openssh-server -y

# Instal ProFTPD
sudo apt install proftpd -y

# Konfigurasi ProFTPD (opsional)
# Anda dapat menyesuaikan konfigurasi ProFTPD di /etc/proftpd/proftpd.conf

# Buat direktori untuk WordPress dan Nagios
mkdir ~/docker-projects
cd ~/docker-projects
mkdir wordpress
mkdir nagios

# Buat file docker-compose.yml untuk WordPress
cat <<EOF > wordpress/docker-compose.yml
version: '3.8'

services:
  db:
    image: mariadb:10.5.8-focal
    volumes:
      - ./data/db:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: nz404dev
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: nz404dev
    expose:
      - 3306
    networks:
      - wordpress-network

  wordpress:
    image: wordpress:latest
    ports:
      - 80:80
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: nz404dev
    depends_on:
      - db
    networks:
      - wordpress-network

networks:
  wordpress-network:
    driver: bridge
EOF

# Buat file docker-compose.yml untuk Nagios
cat <<EOF > nagios/docker-compose.yml
version: '3.8'

services:
  nagios:
    image: jasonrivers/nagios4:latest
    ports:
      - 8080:80
    restart: always
    environment:
      NAGIOSADMIN_PASSWORD: nz404dev
    networks:
      - nagios-network

networks:
  nagios-network:
    driver: bridge
EOF

# Jalankan Docker Compose
cd ~/docker-projects/wordpress
docker compose up -d
cd ~/docker-projects/nagios
docker compose up -d

echo "Instalasi Docker, WordPress, Nagios, SSH, dan ProFTPD selesai!"
