#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck
# Co-Author: MickLesk (Canbiz)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
   _____                   __                    
  / ___/____  ____  ____  / /___ ___  ____ _____ 
  \__ \/ __ \/ __ \/ __ \/ / __ `__ \/ __ `/ __ \
 ___/ / /_/ / /_/ / /_/ / / / / / / / /_/ / / / /
/____/ .___/\____/\____/_/_/ /_/ /_/\__,_/_/ /_/ 
    /_/                                                         
EOF
}
header_info
echo -e "Loading..."
APP="Spoolman"
var_disk="4"
var_cpu="1"
var_ram="1024"
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
if [[ ! -d /opt/spoolman ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
if (( $(df /boot | awk 'NR==2{gsub("%","",$5); print $5}') > 80 )); then
  read -r -p "Warning: Storage is dangerously low, continue anyway? <y/N> " prompt
  [[ ${prompt,,} =~ ^(y|yes)$ ]] || exit
fi
RELEASE=$(wget -q https://github.com/Donkie/Spoolman/releases/latest -O - | grep "title>Release" | cut -d " " -f 4)
if [[ ! -f /opt/${APP}_version.txt ]] || [[ "${RELEASE}" != "$(cat /opt/${APP}_version.txt)" ]]; then

  msg_info "Stopping ${APP} Service"
  systemctl stop spoolman
  msg_ok "Stopped ${APP} Service"

  msg_info "Updating ${APP} to ${RELEASE}"
  cd /opt
  rm -rf spoolman_bak
  mv spoolman spoolman_bak
  wget -q https://github.com/Donkie/Spoolman/releases/download/${RELEASE}/spoolman.zip 
  unzip -q spoolman.zip -d spoolman 
  cd spoolman
  pip3 install -r requirements.txt >/dev/null 2>&1
  cp .env.example .env
  echo "${RELEASE}" >/opt/${APP}_version.txt
  msg_ok "Updated ${APP} to ${RELEASE}"

  msg_info "Starting ${APP} Service"
  systemctl start spoolman
  msg_ok "Started ${APP} Service"

  msg_info "Cleaning up"
  rm -rf /opt/spoolman.zip
  msg_ok "Cleaned"

  msg_ok "Updated Successfully!\n"
else
  msg_ok "No update required. ${APP} is already at ${RELEASE}"
fi
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} Setup should be reachable by going to the following URL.
         ${BL}http://${IP}:7912${CL} \n"
