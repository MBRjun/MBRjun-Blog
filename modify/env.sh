#!/bin/bash

sudo apt install nodejs npm
#to do: switch to yarn
wget -O ./nodejs.tar.xz https://nodejs.org/dist/v19.2.0/node-v19.2.0-linux-x64.tar.xz
tar -xvf ./nodejs.tar.xz
cd node-v19.2.0-linux-x64
sudo cp -R ./* /usr
#thats fuck-apt command
sudo npm install -g npm@latest
#GOODCOMMAND
cp modify/theme.yml themes/tranquilpeak/_config.yml
cd themes/tranquilpeak
npm install && npm run prod
#Install theme
echo Finish.
