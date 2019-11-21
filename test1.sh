#!/bin/bash
# GET ALL USER INPUT
echo "Updating Your OS................."
sleep 2;
sudo apt update -y
sudo apt install apache2 -y
sudo apt-get install mariadb-server mariadb-client -y
sudo mysql_secure_installation -y

echo "Installing Password"
sleep 2;
    Enter current password for root (enter for none): Just press the -Enter
    Set root password? [Y/n]: -Y
    New password: palman00$$ -Enter password
    Re-enter new password: palman00$$ -Repeat password
    Remove anonymous users? [Y/n]: -Y
    Disallow root login remotely? [Y/n]: -Y
    Remove test database and access to it? [Y/n]:  -Y
    Reload privilege tables now? [Y/n]:  -Y
