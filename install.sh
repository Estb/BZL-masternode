#!/bin/bash

echo "Updating linux packages"
sudo apt-get update && apt-get upgrade -y

echo "Intalling fail2ban"
sudo apt install fail2ban

echo "Installing Firewall"
sudo apt install ufw -y
ufw default allow outgoing
ufw default deny incoming
ufw allow ssh/tcp
ufw limit ssh/tcp
ufw allow 33339/tcp
ufw allow 9999/tcp
ufw logging on
ufw --force enable

echo "Installing 2G Swapfile"
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "Installing Dependencies"
sudo apt-get install software-properties-common -y
sudo apt-get install build-essential libssl-dev libboost-all-dev libminiupnpc-dev libqrencode-dev
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get -y install libdb4.8++-dev

echo "Installing Denarius Wallet"
git clone https://github.com/carsenk/denarius
cd denarius
git checkout master
cd src
make -f makefile.unix

echo "Get Chaindata"
apt-get -y install unzip
cd ~/.denarius
rm -rf database txleveldb smsgDB
wget https://gitlab.com/denarius/chaindata/raw/master/chaindata.zip
unzip chaindata.zip
