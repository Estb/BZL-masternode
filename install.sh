#!/bin/bash

echo "Updating linux packages"
sudo apt-get update && apt-get upgrade -y

echo "Intalling screen"
apt install screen

echo "Installing git"
apt install git -y

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

echo "Installing PWGEN"
apt-get install -y pwgen

echo "Installing 2G Swapfile"
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "Installing Dependencies"
apt-get --assume-yes install git unzip build-essential libssl-dev libdb++-dev libboost-all-dev libcrypto++-dev libqrencode-dev libminiupnpc-dev libgmp-dev libgmp3-dev autoconf autogen automake  libtool

echo "Downloading Denarius Wallet"
wget https://github.com/carsenk/denarius/releases/download/v2.5/denariusd-2.5.0.0_ubuntu16.tar.gz
tar -xvf denariusd-2.5.0.0_ubuntu16.tar.gz -C /usr/local/bin
mv /usr/local/bin/denariusd-2.5.0.0_ubuntu16 /usr/local/bin/denariusd
rm denariusd-2.5.0.0_ubuntu16.tar.gz

#echo "Installing Denarius Wallet"
#git clone https://github.com/carsenk/denarius
#cd denarius
#git checkout master
#cd src
#make -f makefile.unix

echo "Populate denarius.conf"
sudo mkdir  /root/.denarius
IP=$(curl ipinfo.io/ip)
USERNAME=$(pwgen -s 16 1)
PASSWORD=$(pwgen -s 64 1)
echo -n "What is your masternodeprivkey? (Hint:genkey output)"
read MASTERNODEPRIVKEY
echo "rpcuser=$USERNAME" > /root/.denarius/denarius.conf
echo "rpcpassword=$PASSWORD" /root/.denarius/denarius.conf
echo "server=1" >> /root/.denarius/denarius.conf
echo "listen=1" >> /root/.denarius/denarius.conf
echo "port=9999" >> /root/.denarius/denarius.conf
echo "rpcport=33339" >> /root/.denarius/denarius.conf
echo "addnode=denarius.host" >> /root/.denarius/denarius.conf
echo "maxconnections=16" >> /root/.denarius/denarius.conf
echo "masternodeprivkey=$MASTERNODEPRIVKEY" >> /root/.denarius/denarius.conf
echo "masternode=1" >> /root/.denarius/denarius.conf
echo "masternodeaddr=$IP:9999" >> /root/.denarius/denarius.conf

echo "Get Chaindata"
apt-get -y install unzip
cd ~/.denarius
rm -rf database txleveldb smsgDB
wget https://gitlab.com/denarius/chaindata/raw/master/chaindata.zip
unzip chaindata.zip

echo "Starting Denarius Daemon"
sudo denariusd --daemon
#echo "Run ./denariusd"
#screen -dmS denariusd /denarius/src/./denariusd
