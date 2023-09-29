#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
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

msg_info "Updating Python3"
$STD apt-get install -y \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv

msg_ok "Updated Python3"

msg_info "Installing ESPHome"
#mkdir /srv/esphome
#cd /srv/esphome
#python3 -m venv .
#source bin/activate
$STD pip install esphome tornado esptool
echo "bash -c \"\$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/${app}.sh)\"" >/usr/bin/update
chmod +x /usr/bin/update
msg_ok "Installed ESPHome"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/esphomeDashboard.service
[Unit]
Description=ESPHome Dashboard
After=network.target

[Service]
#ExecStart=/srv/esphome/bin/esphome dashboard /root/config/
ExecStart=/usr/local/bin/esphome dashboard /root/config/
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now esphomeDashboard.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
