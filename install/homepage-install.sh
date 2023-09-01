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

install_nodejs 18

msg_info "Installing pnpm"
$STD npm install -g pnpm
msg_ok "Installed pnpm"

msg_info "Installing Homepage (Patience)"
cd /opt
$STD git clone https://github.com/benphelps/homepage.git
cd /opt/homepage
mkdir -p config
cp /opt/homepage/src/skeleton/* /opt/homepage/config
$STD pnpm install
$STD pnpm build
msg_ok "Installed Homepage"

msg_info "Creating Service"
service_path="/etc/systemd/system/homepage.service"
echo "[Unit]
Description=Homepage
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
WorkingDirectory=/opt/homepage/
ExecStart=pnpm start
[Install]
WantedBy=multi-user.target" >$service_path
$STD systemctl enable --now homepage
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
