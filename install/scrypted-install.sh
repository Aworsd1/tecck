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

msg_info "Installing Dependencies (Patience)"
$STD apt-get -y install software-properties-common apt-utils
$STD apt-get -y update
$STD apt-get -y upgrade
$STD apt-get install -y avahi-daemon
$STD apt-get -y install \
    build-essential \
    gcc \
    gir1.2-gtk-3.0 \
    libcairo2-dev \
    libgirepository1.0-dev \
    libglib2.0-dev \
    libjpeg-dev \
    libgif-dev \
    libopenjp2-7 \
    libpango1.0-dev \
    librsvg2-dev \
    pkg-config \
    curl \
    sudo \
    mc \
    ca-certificates \
    gnupg
msg_ok "Installed Dependencies"

if [[ "$CTTYPE" == "0" ]]; then
  msg_info "Setting Up Hardware Acceleration"
  $STD apt-get -y install \
    va-driver-all \
    ocl-icd-libopencl1 \
    intel-opencl-icd

  /bin/chgrp video /dev/dri
  /bin/chmod 755 /dev/dri
  /bin/chmod 660 /dev/dri/*
  msg_ok "Set Up Hardware Acceleration"
fi
msg_info "Installing GStreamer (Patience)"
$STD apt-get -y install \
    gstreamer1.0-tools \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-alsa
msg_ok "Installed GStreamer"

msg_info "Setting up Node.js Repository"
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" >/etc/apt/sources.list.d/nodesource.list
msg_ok "Set up Node.js Repository"

msg_info "Installing Node.js"
$STD apt-get update
$STD apt-get install -y nodejs
msg_ok "Installed Node.js"

msg_info "Updating Python3"
$STD apt-get install -y \
  python3 \
  python3-dev \
  python3-pip
msg_ok "Updated Python3"

msg_info "Installing Python3 Dependencies"
$STD apt-get -y install \
    python3-gi \
    python3-gst-1.0 \
    python3-matplotlib \
    python3-numpy \
    python3-opencv \
    python3-pil \
    python3-setuptools \
    python3-skimage \
    python3-wheel
$STD python3 -m pip install --upgrade pip
$STD python3 -m pip install aiofiles debugpy typing_extensions typing
msg_ok "Installed Python3 Dependencies"

read -r -p "Would you like to add Coral Edge TPU support? <y/N> " prompt
if [[ "${prompt,,}" =~ ^(y|yes)$ ]]; then
msg_info "Adding Coral Edge TPU Support"
wget -qO /etc/apt/trusted.gpg.d/coral-repo.asc "https://packages.cloud.google.com/apt/doc/apt-key.gpg"
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" >/etc/apt/sources.list.d/coral-edgetpu.list
$STD apt-get -y update
$STD apt-get -y install libedgetpu1-std
msg_ok "Coral Edge TPU Support Added"
fi

msg_info "Installing Scrypted"
$STD npx -y scrypted@latest install-server
msg_ok "Installed Scrypted"

msg_info "Creating Service"
service_path="/etc/systemd/system/scrypted.service"
echo "[Unit]
Description=Scrypted service
After=network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/bin/npx -y scrypted serve
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target" >$service_path
$STD systemctl enable --now scrypted.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
