#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

ubuntuversion=$(lsb_release -r | awk '{print $2}' | cut -d . -f1)
if [ "$ubuntuversion" = "18" ] || [ "$ubuntuversion" -le "18" ]; then
    apt install sudo wget -y
    sudo apt install -y software-properties-common
    sudo add-apt-repository universe -y
    apt update -y
    apt update --fix-missing -y
fi

msg_info "Installing Dependencies"
$STD apt-get install -y curl sudo git mc
$STD apt-get install -y make zip net-tools
$STD apt-get install -y gcc g++ cmake
$STD apt-get install -y ca-certificates
$STD apt-get install -y gnupg
msg_ok "Installed Dependencies"

msg_info "Setting up Node.js Repository"
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" >/etc/apt/sources.list.d/nodesource.list
msg_ok "Set up Node.js Repository"

msg_info "Installing Node.js"
$STD apt-get update
$STD apt-get install -y nodejs
msg_ok "Installed Node.js"

msg_info "Installing FFMPEG"
$STD apt-get install -y ffmpeg
msg_ok "Installed FFMPEG"

msg_info "Clonning Shinobi"
cd /opt
$STD git clone https://gitlab.com/Shinobi-Systems/Shinobi.git -b master Shinobi
cd Shinobi
gitVersionNumber=$(git rev-parse HEAD)
theDateRightNow=$(date)
touch version.json
chmod 777 version.json
echo '{"Product" : "'"Shinobi"'" , "Branch" : "'"master"'" , "Version" : "'"$gitVersionNumber"'" , "Date" : "'"$theDateRightNow"'" , "Repository" : "'"https://gitlab.com/Shinobi-Systems/Shinobi.git"'"}' > version.json
msg_ok "Cloned Shinobi"

msg_info "Installing Database"
sqlpass=""
echo "mariadb-server mariadb-server/root_password password $sqlpass" | debconf-set-selections
echo "mariadb-server mariadb-server/root_password_again password $sqlpass" | debconf-set-selections
$STD apt-get install -y mariadb-server
service mysql start
sqluser="root"
mysql -e "source sql/user.sql" || true
mysql -e "source sql/framework.sql" || true
msg_ok "Installed Database"
cp conf.sample.json conf.json
cronKey=$(head -c 1024 < /dev/urandom | sha256sum | awk '{print substr($1,1,29)}')
sed -i -e 's/Shinobi/'"$cronKey"'/g' conf.json
cp super.sample.json super.json

msg_info "Installing Shinobi"
$STD npm i npm -g
$STD npm install --unsafe-perm
$STD npm install pm2@latest -g
chmod -R 755 .
touch INSTALL/installed.txt
ln -s /opt/Shinobi/INSTALL/shinobi /usr/bin/shinobi
node /opt/Shinobi/tools/modifyConfiguration.js addToConfig="{\"cron\":{\"key\":\"$(head -c 64 < /dev/urandom | sha256sum | awk '{print substr($1,1,60)}')\"}}" &>/dev/null
$STD pm2 start camera.js
$STD pm2 start cron.js
$STD pm2 startup
$STD pm2 save
$STD pm2 list
msg_ok "Installed Shinobi"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
