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
msg_ok "Installed Dependencies"

msg_info "Updating Python"
$STD apt-get install -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv
msg_ok "Updated Python"

get_latest_release() {
  curl -sL https://api.github.com/repos/$1/releases/latest | grep '"tag_name":' | cut -d'"' -f4
}

DOCKER_LATEST_VERSION=$(get_latest_release "moby/moby")
RHASSPY_LATEST_VERSION=$(get_latest_release "rhasspy/rhasspy")

msg_info "Installing Docker $DOCKER_LATEST_VERSION"
DOCKER_CONFIG_PATH='/etc/docker/daemon.json'
mkdir -p $(dirname $DOCKER_CONFIG_PATH)
if [ "$ST" == "yes" ]; then
  VER=$(curl -s https://api.github.com/repos/containers/fuse-overlayfs/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
  cd /usr/local/bin
  curl -sSL -o fuse-overlayfs https://github.com/containers/fuse-overlayfs/releases/download/$VER/fuse-overlayfs-x86_64
  chmod 755 /usr/local/bin/fuse-overlayfs
  cd ~
  echo -e '{\n  "storage-driver": "fuse-overlayfs",\n  "log-driver": "journald"\n}' >/etc/docker/daemon.json
else
  echo -e '{\n  "log-driver": "journald"\n}' >/etc/docker/daemon.json
fi
$STD sh <(curl -sSL https://get.docker.com)
msg_ok "Installed Docker $DOCKER_LATEST_VERSION"

msg_info "Pulling Rhasspy $CORE_LATEST_VERSION Image"
$STD docker rhasspy/rhasspy:latest
msg_ok "Pulled Rhasspy $CORE_LATEST_VERSION Image"

msg_info "Installing Rhasspy"
$STD docker volume create rhasspy_profiles
$STD docker run -d \
    -p 12101:12101 \
    --name=rhasspy \
    --restart=always \
    -v "rhasspy_profiles:/profiles" \
    -v "/etc/localtime:/etc/localtime:ro" \
    --device /dev/snd:/dev/snd \
    rhasspy/rhasspy:latest \
    --user-profiles /profiles \
    --profile en
mkdir /root/rhasspy_profiles
msg_ok "Installed Rhasspy"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"