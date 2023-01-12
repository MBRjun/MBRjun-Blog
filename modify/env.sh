#!/bin/bash

echo -e "\033[41;37mDeprecated: env.sh, please switch to make. Continue after 10 seconds.\033[0m"
sleep 10
sudo apt install nodejs npm neofetch
#to do: switch to yarn
wget -O ./nodejs.tar.xz https://nodejs.org/dist/v19.4.0/node-v19.4.0-linux-x64.tar.xz
tar -xf ./nodejs.tar.xz
cd node-v19.4.0-linux-x64
sudo cp -R ./* /usr
#thats fuck-apt command
sudo npm install -g npm@latest
#GOODCOMMAND
cd ..
npm install
npm install hexo-cli -g
#忘了写安装hexo的命令（你看这人怎么还写中文注释
cp modify/theme.yml themes/tranquilpeak/_config.yml
cp modify/zh-cn.yml themes/tranquilpeak/languages/zh-cn.yml
cp modify/footer.ejs themes/tranquilpeak/layout/_partial/footer.ejs
cp modify/post.ejs themes/tranquilpeak/layout/_partial/post.ejs
cd themes/tranquilpeak
npm install && npm run prod
#Install theme
echo Finish.
