#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
  clear
  cat <<"EOF"
   ______           ____                 
  / ____/________ _/ __/___ _____  ____ _
 / / __/ ___/ __  / /_/ __  / __ \/ __  /
/ /_/ / /  / /_/ / __/ /_/ / / / / /_/ / 
\____/_/   \__,_/_/  \__,_/_/ /_/\__,_/  
 Alpine
 
EOF
}
header_info
echo -e "Loading..."
APP="Alpine-Grafana"
var_disk="0.5"
var_cpu="1"
var_ram="256"
var_os="alpine"
var_version="3.18"
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
  if ! apk -e info newt >/dev/null 2>&1; then
    apk add -q newt
  fi
  LXCIP=$(ip a s dev eth0 | awk '/inet / {print $2}' | cut -d/ -f1)
  while true; do
    CHOICE=$(
      whiptail --backtitle "Proxmox VE Helper Scripts" --title "SUPPORT" --menu "Select option" 11 58 3 \
        "1" "Check for Grafana Updates" \
        "2" "Allow 0.0.0.0 for listening" \
        "3" "Allow only ${LXCIP} for listening" 3>&2 2>&1 1>&3
    )
    exit_status=$?
    if [ $exit_status == 1 ]; then
      clear
      exit-script
    fi
    header_info
    case $CHOICE in
    1)
      apk update && apk upgrade
      exit
      ;;
    2)
      sed -i -e "s/cfg:server.http_addr=.*/cfg:server.http_addr=0.0.0.0/g" /etc/conf.d/grafana
      service grafana restart
      exit
      ;;
    3)
      sed -i -e "s/cfg:server.http_addr=.*/cfg:server.http_addr=$LXCIP/g" /etc/conf.d/grafana
      service grafana restart
      exit
      ;;
    esac
  done
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:3000${CL} \n"
