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
ufw allow 27777/tcp
ufw allow 27776/tcp
ufw allow 7771/tcp
ufw allow 7772/tcp
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

#echo "Downloading BZlcoin Wallet"
#wget https://github.com/bzlcoin/bzlcoin/archive/2.0.tar.gz
#tar -xvf bzlcoin-2.0.tar.gz -C /usr/local/bin
#mv /usr/local/bin/bzlcoin-2.0 /usr/local/bin/bzlcoind
#rm bzlcoin-2.0.tar.gz

echo "Download and Compile Bzlcoin Wallet"
git clone https://github.com/bzlcoin/bzlcoin
cd bzlcoin
git checkout master
cd src
make -f makefile.unix
mv /root/bzlcoin/src/bzlcoin /usr/local/bin/bzlcoin

echo "Populate bzlcoin.conf"
sudo mkdir  /root/.bzlcoin
    # Get VPS IP Address
    VPSIP=$(curl ipinfo.io/ip)
    # create rpc user and password
    rpcuser=$(openssl rand -base64 24)
    # create rpc password
    rpcpassword=$(openssl rand -base64 48)
    echo -n "What is your masternodeprivkey? (Hint:genkey output)"
    read MASTERNODEPRIVKEY
    echo -e "rpcuser=$rpcuser\nrpcpassword=$rpcpassword\nserver=1\nlisten=1\nmaxconnections=100\ndaemon=1\nport=27777\nstaking=0\nrpcallowip=127.0.0.1\nexternalip=$VPSIP:27777\nmasternode=1\nmasternodeprivkey=$MASTERNODEPRIVKEY" > /root/.bzlcoin/bzlcoin.conf


echo "Get Chaindata"
cd ~/.bzlcoin
rm -rf database txleveldb smsgDB
wget https://bzlcoin.org/chaindata/chaindata.zip
unzip chaindata.zip

echo "Starting Bzlcoin Daemon"
sudo bzlcoin/src/bzlcoind --daemon
#echo "Run ./bzlcoind"
#screen -dmS bzlcoind /bzlcoin/src/./bzlcoind
