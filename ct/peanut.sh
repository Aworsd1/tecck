#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/remz1337/Proxmox/remz/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# Co-Author: remz1337
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ____                         __ 
   / __ \___  ____ _____  __  __/ /_
  / /_/ / _ \/ __ `/ __ \/ / / / __/
 / ____/  __/ /_/ / / / / /_/ / /_  
/_/    \___/\__,_/_/ /_/\__,_/\__/  

EOF
}
header_info
echo -e "Loading..."
APP="Peanut"
var_disk="4"
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
  if [[ ! -f /etc/systemd/system/peanut.service ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
  RELEASE=$(curl -sL https://api.github.com/repos/Brandawg93/PeaNUT/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
  if [[ ! -f /opt/${APP}_version.txt ]] || [[ "${RELEASE}" != "$(cat /opt/${APP}_version.txt)" ]]; then
    msg_info "Updating $APP LXC"
    systemctl stop peanut
    wget -qO peanut.tar.gz https://api.github.com/repos/Brandawg93/PeaNUT/tarball/${RELEASE}
    tar -xzf peanut.tar.gz -C /opt/peanut --strip-components 1
    rm peanut.tar.gz
    cd /opt/peanut
    pnpm i &>/dev/null
    pnpm run build &>/dev/null
    cp -r .next/static .next/standalone/.next/
    systemctl start peanut
    echo "${RELEASE}" >/opt/${APP}_version.txt
    msg_ok "Updated $APP to ${RELEASE}"
  else
    msg_ok "No update required. ${APP} is already at ${RELEASE}"
  fi
  exit
}

start
build_container
description

msg_info "Setting Container to Normal Resources"
pct set $CTID -memory 1024
pct set $CTID -cores 1
msg_ok "Set Container to Normal Resources"
msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:3000${CL} \n"
