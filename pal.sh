https://github.com/muskanpulyani/opencartscript/blob/master/home/ubuntu/first.sh


#!/bin/bash
# GET ALL USER INPUT
echo "Updating Your OS................."
sleep 2;
sudo apt update -y
sudo apt install apache2 -y
sudo apt-get install mariadb-server mariadb-client -y
sudo mysql_secure_installation -y
sudo mysql -u root -p
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php7.1 libapache2-mod-php7.1 php7.2-common php7.1-sqlite3 php7.1-curl php7.1-intl php7.1-mbstring php7.1-mcrypt php7.1-xmlrpc php7.1-mysql php7.1-gd php7.1-xml php7.1-cli php7.1-zip


echo "Installing Nginx"
sleep 2;
sudo apt-get install nginx -y
sudo apt-get install zip -y
sudo apt install unzip -y

echo "Sit back and relax :) ......"
sleep 2;
cd /etc/nginx/sites-available/
wget -O "$DOMAIN" https://raw.githubusercontent.com/abokareem/opencart/master/Cloudflare%20FULL%20SSL%20nginx
sed -i -e "s/example.com/$DOMAIN/" "$DOMAIN"
sed -i -e "s/www.example.com/www.$DOMAIN/" "$DOMAIN"
sudo ln -s /etc/nginx/sites-available/"$DOMAIN" /etc/nginx/sites-enabled/

echo "Setting up Cloudflare FULL SSL"
sleep 2;
sudo mkdir /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt
sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
cd /etc/nginx/
sudo mv nginx.conf nginx.conf.backup
wget -O nginx.conf https://raw.githubusercontent.com/abokareem/opencart/master/nginx.conf
sudo mkdir /var/www/"$DOMAIN"
cd /var/www/"$DOMAIN"
sudo su -c 'echo "<?php phpinfo(); ?>" |tee info.php'
cd ~
wget https://arastta.org/download.php?version=latest
sudo mv 'download.php?version=latest' arastta.zip
unzip arastta.zip
mv /root/arastta/upload/* /var/www/"$DOMAIN"/
sudo cp /var/www/"$DOMAIN"/config-dist.php /var/www/"$DOMAIN"/config.php
sudo cp /var/www/"$DOMAIN"/admin/config-dist.php /var/www/"$DOMAIN"/admin/config.php

rm -rf arastta.zip

sudo chown -R www-data:www-data /var/www/html/arastta/
sudo chmod -R 755 /var/www/html/arastta/


echo "Nginx server installation completed"
sleep 2;
cd ~
sudo chown www-data:www-data -R /var/www/"$DOMAIN"
sudo chown www-data:www-data -R /var/www
sudo systemctl restart nginx.service

echo "lets install php 7.1 and modules"
sleep 2;
sudo apt install php7.0 php7.1-fpm pwgen -y
sudo mysql -u root -p
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install php7.1 libapache2-mod-php7.1 php7.2-common php7.1-sqlite3 php7.1-curl php7.1-intl php7.1-mbstring php7.1-mcrypt php7.1-xmlrpc php7.1-mysql php7.1-gd php7.1-xml php7.1-cli php7.1-zip
echo "Some php.ini tweaks"
sleep 2;
sudo sed -i "s/file_uploads = .*/file_uploads = On/" /etc/php/7.1/apache2/php.ini
sudo sed -i "s/allow_url_fopen = .*/allow_url_fopen = On/" /etc/php/7.1/apache2/php.ini
sudo sed -i "s/short_open_tag = .*/short_open_tag = On/" /etc/php/7.1/apache2/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 256M/" /etc/php/7.1/apache2/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/apache2/php.ini
sudo sed -i "s/max_execution_time = .*/max_execution_time = 360/" /etc/php/7.1/apache2/php.ini
sudo sed -i "s/date.timezone = .*/date.timezone = America/Chicago/" /etc/php/7.1/apache2/php.ini


echo "Some phpinfo.php tweaks"
sleep 2;
sudo systemctl restart apache2.service
sudo sed -i "s/ = .*/ = <?php phpinfo( ); ?>/" /var/www/html/phpinfo.php

sudo systemctl restart php7.0-fpm.service

echo "Instaling MariaDB"
sleep 2;
sudo apt install mariadb-server mariadb-client php7.0-mysql -y
sudo systemctl restart php7.0-fpm.service
sudo mysql_secure_installation
PASS=`pwgen -s 14 1`

mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE $USERNAME;
CREATE DATABASE $USERNAME;
CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASS';
FLUSH PRIVILEGES;
MYSQL_SCRIPT


sudo a2ensite arastta.conf
sudo a2enmod rewrite
sudo systemctl restart apache2.service

echo "Here is the database"
echo "Database:   $USERNAME"
echo "Username:   $USERNAME"
echo "Password:   $PASS"
