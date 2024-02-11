#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ___       __                           __
   /   | ____/ /___ ___  ______ __________/ /
  / /| |/ __  / __  / / / / __  / ___/ __  / 
 / ___ / /_/ / /_/ / /_/ / /_/ / /  / /_/ /  
/_/  |_\__,_/\__, /\__,_/\__,_/_/   \__,_/   
            /____/                           
 
EOF
}
header_info
echo -e "Loading..."
APP="Adguard"
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
if [[ ! -d /opt/AdGuardHome ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
if (( $(df /boot | awk 'NR==2{gsub("%","",$5); print $5}') > 80 )); then
  read -r -p "Warning: Storage is dangerously low, continue anyway? <y/N> " prompt
  [[ ${prompt,,} =~ ^(y|yes)$ ]] || exit
fi
wget -qL https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz
msg_info "Stopping AdguardHome"
systemctl stop AdGuardHome
msg_ok "Stopped AdguardHome"

msg_info "Updating AdguardHome"
tar -xvf AdGuardHome_linux_amd64.tar.gz &>/dev/null
mkdir -p adguard-backup
cp -r /opt/AdGuardHome/AdGuardHome.yaml /opt/AdGuardHome/data adguard-backup/
cp AdGuardHome/AdGuardHome /opt/AdGuardHome/AdGuardHome
cp -r adguard-backup/* /opt/AdGuardHome/
msg_ok "Updated AdguardHome"

msg_info "Starting AdguardHome"
systemctl start AdGuardHome
msg_ok "Started AdguardHome"

msg_info "Cleaning Up"
rm -rf AdGuardHome_linux_amd64.tar.gz AdGuardHome adguard-backup
msg_ok "Cleaned"
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} Setup should be reachable by going to the following URL.
         ${BL}http://${IP}:3000${CL} \n"
