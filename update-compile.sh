#!/bin/bash

echo "Updating Denarius Wallet"
denariusd stop
cd denarius
git checkout master
git pull
cd src
make -f makefile.unix
mv /root/denarius/src/denariusd /usr/local/bin/denariusd

echo "Starting Updated Denarius Daemon"
sudo denariusd --daemon
