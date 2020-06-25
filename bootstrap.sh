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