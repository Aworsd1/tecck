#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
   _____ ___    ____              __        __
  / ___//   |  / __ )____  ____  / /_  ____/ /
  \__ \/ /| | / __  / __ \/_  / / __ \/ __  / 
 ___/ / ___ |/ /_/ / / / / / /_/ /_/ / /_/ /  
/____/_/  |_/_____/_/ /_/ /___/_.___/\__,_/   
                                              
EOF
}
header_info
echo -e "Loading..."
APP="SABnzbd"
var_disk="8"
var_cpu="2"
var_ram="2048"
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
if [[ ! -d /opt/sabnzbd ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating $APP"
systemctl stop sabnzbd.service
RELEASE=$(curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
tar zxvf <(curl -fsSL https://github.com/sabnzbd/sabnzbd/releases/download/$RELEASE/SABnzbd-${RELEASE}-src.tar.gz) &>/dev/null
\cp -r SABnzbd-${RELEASE}/* /opt/sabnzbd &>/dev/null
rm -rf SABnzbd-${RELEASE}
cd /opt/sabnzbd
python3 -m pip install -r requirements.txt &>/dev/null
systemctl start sabnzbd.service
msg_ok "Updated $APP"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:7777${CL} \n"
