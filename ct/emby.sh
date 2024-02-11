#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ______          __         
   / ____/___ ___  / /_  __  __
  / __/ / __  __ \/ __ \/ / / /
 / /___/ / / / / / /_/ / /_/ / 
/_____/_/ /_/ /_/_.___/\__, /  
                      /____/   
EOF
}
header_info
echo -e "Loading..."
APP="Emby"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="ubuntu"
var_version="20.04"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="0"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/emby-server ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
LATEST=$(curl -sL https://api.github.com/repos/MediaBrowser/Emby.Releases/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
msg_info "Stopping ${APP}"
systemctl stop emby-server
msg_ok "Stopped ${APP}"

msg_info "Updating ${APP}"
wget https://github.com/MediaBrowser/Emby.Releases/releases/download/${LATEST}/emby-server-deb_${LATEST}_amd64.deb &>/dev/null
dpkg -i emby-server-deb_${LATEST}_amd64.deb &>/dev/null
rm emby-server-deb_${LATEST}_amd64.deb
msg_ok "Updated ${APP}"

msg_info "Starting ${APP}"
systemctl start emby-server
msg_ok "Started ${APP}"
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
             ${BL}http://${IP}:8096${CL}\n"
