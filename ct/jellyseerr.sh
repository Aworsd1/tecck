#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
       __     ____
      / /__  / / /_  __________  ___  __________
 __  / / _ \/ / / / / / ___/ _ \/ _ \/ ___/ ___/
/ /_/ /  __/ / / /_/ (__  )  __/  __/ /  / /
\____/\___/_/_/\__, /____/\___/\___/_/  /_/
              /____/
EOF
}
header_info
echo -e "Loading..."
APP="Jellyseerr"
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
if [[ ! -d /opt/jellyseerr ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating $APP"
systemctl stop jellyseerr
cd /opt/jellyseerr
output=$(git pull)
git pull &>/dev/null
if echo "$output" | grep -q "Already up to date."
then
  msg_ok " $APP is already up to date."
  systemctl start jellyseerr
  exit
fi
yarn install &>/dev/null
yarn build &>/dev/null
systemctl start jellyseerr
msg_ok "Updated $APP"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:5055${CL} \n"
