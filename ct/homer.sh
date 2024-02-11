#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    __  __                         
   / / / /___  ____ ___  ___  _____
  / /_/ / __ \/ __ `__ \/ _ \/ ___/
 / __  / /_/ / / / / / /  __/ /    
/_/ /_/\____/_/ /_/ /_/\___/_/     
                                   
EOF
}
header_info
echo -e "Loading..."
APP="Homer"
var_disk="2"
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
if [[ ! -d /opt/homer ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Stopping ${APP}"
systemctl stop homer
msg_ok "Stopped ${APP}"

msg_info "Backing up config.yml"
cd ~
cp -R /opt/homer/assets/config.yml config.yml
cp -R /opt/homer/assets/tools tools
msg_ok "Backed up config.yml and tools directory"

msg_info "Updating ${APP}"
rm -rf /opt/homer/*
cd /opt/homer
wget -q https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip
unzip homer.zip &>/dev/null
msg_ok "Updated ${APP}"
msg_info "Restoring conf.yml"
cd ~
cp -R config.yml /opt/homer/assets
cp -R tools /opt/homer/assets
msg_ok "Restored config.yml and tools directory"

msg_info "Cleaning"
rm -rf config.yml tools /opt/homer/homer.zip
msg_ok "Cleaned"

msg_info "Starting ${APP}"
systemctl start homer
msg_ok "Started ${APP}"
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8010${CL} \n"
