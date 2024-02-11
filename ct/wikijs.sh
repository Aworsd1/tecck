#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
 _       ___ __   _     _     
| |     / (_) /__(_)   (_)____
| | /| / / / //_/ /   / / ___/
| |/ |/ / / ,< / /   / (__  ) 
|__/|__/_/_/|_/_(_)_/ /____/  
                 /___/      
 
EOF
}
header_info
echo -e "Loading..."
APP="Wikijs"
var_disk="3"
var_cpu="1"
var_ram="512"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
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
if [[ ! -d /opt/wikijs ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Stopping ${APP}"
systemctl stop wikijs
msg_ok "Stopped ${APP}"

msg_info "Backing up Data"
mkdir -p ~/data-backup
cp -R /opt/wikijs/{db.sqlite,config.yml,/data} ~/data-backup
msg_ok "Backed up Data"

msg_info "Updating ${APP}"
rm -rf /opt/wikijs/*
cd /opt/wikijs
wget -q https://github.com/Requarks/wiki/releases/latest/download/wiki-js.tar.gz
tar xzf wiki-js.tar.gz 
msg_ok "Updated ${APP}"

msg_info "Restoring Data"
cp -R ~/data-backup/* /opt/wikijs
rm -rf ~/data-backup
npm rebuild sqlite3 &>/dev/null
msg_ok "Restored Data"

msg_info "Starting ${APP}"
systemctl start wikijs
msg_ok "Started ${APP}"
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:3000${CL} \n"
