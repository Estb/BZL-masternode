#!/bin/bash

echo "Updating Bzlcoin Wallet"
bzlcoind stop
cd bzlcoin
git checkout master
git pull
cd src
make -f makefile.unix
mv /root/bzlcoin/src/bzlcoind /usr/local/bin/bzlcoind

echo "Starting Updated Bzlcoin Daemon"
sudo bzlcoind --daemon
