#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ____           ___     
   / __ \___  ____/ (_)____
  / /_/ / _ \/ __  / / ___/
 / _, _/  __/ /_/ / (__  ) 
/_/ |_|\___/\__,_/_/____/  

EOF
}
header_info
echo -e "Loading..."
APP="Redis"
var_disk="4"
var_cpu="1"
var_ram="1024"
var_os="debian"
var_version="12"
VERBOSE="yes"
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
if [[ ! -f /lib/systemd/system/redis-server.service ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_error "There is currently no update path available."
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
