#!/usr/bin/env bash
set -e
if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi
echo "Installing Puppet repo for Ubuntu 12.04 LTS"

#
sudo apt-get update -y
sudo apt upgrade -y


sudo mysql -uroot

ALTER USER root@localhost IDENTIFIED VIA unix_socket;
ALTER USER root@localhost IDENTIFIED VIA mysql_native_password;
SET PASSWORD = PASSWORD('gudubet');
flush privileges;