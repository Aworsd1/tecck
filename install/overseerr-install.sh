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
msg_ok "Installed Dependencies"

install_nodejs 18

msg_info "Installing Yarn"
$STD npm install -g yarn
msg_ok "Installed Yarn"

msg_info "Installing Overseerr (Patience)"
git clone -q https://github.com/sct/overseerr.git /opt/overseerr
cd /opt/overseerr
$STD yarn install
$STD yarn build
msg_ok "Installed Overseerr"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/overseerr.service
[Unit]
Description=Overseerr Service
After=network.target

[Service]
Type=exec
WorkingDirectory=/opt/overseerr
ExecStart=/usr/bin/yarn start

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now overseerr.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
