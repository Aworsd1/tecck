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

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y git
$STD apt-get install -y make
$STD apt-get install -y g++
$STD apt-get install -y gcc
msg_ok "Installed Dependencies"

msg_info "Installing Node.js"
$STD bash <(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh)
. ~/.bashrc
$STD nvm install 16.20.1
ln -sf /root/.nvm/versions/node/v16.20.1/bin/node /usr/bin/node
ln -sf /root/.nvm/versions/node/v16.20.1/bin/npm /usr/bin/npm
msg_ok "Installed Node.js"

msg_info "Installing NocoDB"
$STD git clone https://github.com/nocodb/nocodb-seed
mv nocodb-seed /opt/nocodb
cd /opt/nocodb
$STD npm install
msg_ok "Installed NocoDB"

msg_info "Creating Service"
service_path="/etc/systemd/system/nocodb.service"
echo "[Unit]
Description=nocodb

[Service]
Type=simple
Restart=always
User=root
WorkingDirectory=/opt/nocodb
ExecStart=/usr/bin/npm start

[Install]
WantedBy=multi-user.target" >$service_path
systemctl enable --now nocodb.service &>/dev/null
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
