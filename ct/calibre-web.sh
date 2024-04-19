#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# Co-Author: remz1337
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
   ______      ___ __                                 __  
  / ____/___ _/ (_) /_  ________       _      _____  / /_ 
 / /   / __ `/ / / __ \/ ___/ _ \_____| | /| / / _ \/ __ \
/ /___/ /_/ / / / /_/ / /  /  __/_____/ |/ |/ /  __/ /_/ /
\____/\__,_/_/_/_.___/_/   \___/      |__/|__/\___/_.___/ 
                                                          
EOF
}
header_info
echo -e "Loading..."
APP="Calibre-web"
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
  if [[ ! -f /etc/systemd/system/cps.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  header_info
  msg_info "Updating $APP LXC"
  systemctl stop cps
  cd /opt/kepubify
  rm kepubify-linux-64bit
  curl -fsSLO https://github.com/pgaskin/kepubify/releases/latest/download/kepubify-linux-64bit &>/dev/null
  chmod +x kepubify-linux-64bit
  rm /opt/calibre-web/metadata.db
  wget https://github.com/janeczku/calibre-web/raw/master/library/metadata.db -P /opt/calibre-web
  menu_array=("1" "Enables gdrive as storage backend for your ebooks" OFF \
    "2" "Enables sending emails via a googlemail account without enabling insecure apps" OFF \
    "3" "Enables displaying of additional author infos on the authors page" OFF \
    "4" "Enables login via LDAP server" OFF \
    "5" "Enables login via google or github oauth" OFF \
    "6" "Enables extracting of metadata from epub, fb2, pdf files, and also extraction of covers from cbr, cbz, cbt files" OFF \
    "7" "Enables extracting of metadata from cbr, cbz, cbt files" OFF \
    "8" "Enables syncing with your kobo reader" OFF )
  if [ -f "/opt/calibre-web/options.txt" ]; then
    cps_options="$(cat /opt/calibre-web/options.txt)"
    IFS=',' read -ra ADDR <<< "$cps_options"
    for i in "${ADDR[@]}"; do
	  if [ $i == "gdrive" ]; then
	    line=0
	  elif [ $i == "gmail" ]; then
	    line=1
      elif [ $i == "goodreads" ]; then
	    line=2
	  elif [ $i == "ldap" ]; then
	    line=3
	  elif [ $i == "oauth" ]; then
	    line=4
	  elif [ $i == "metadata" ]; then
	    line=5
	  elif [ $i == "comics" ]; then
	    line=6
	  elif [ $i == "kobo" ]; then
	    line=7
	  fi
      array_index=$(( 3*line + 2 ))
      menu_array[$array_index]=ON
    done
  fi
  if [ -n "$SPINNER_PID" ] && ps -p $SPINNER_PID > /dev/null; then kill $SPINNER_PID > /dev/null; fi
  CHOICES=$(whiptail --backtitle "Proxmox VE Helper Scripts" --title "CALIBRE-WEB OPTIONS" --separate-output --checklist "Choose Additional Options" 15 125 8 "${menu_array[@]}" 3>&1 1>&2 2>&3)
  spinner &
  SPINNER_PID=$!
  if [ ! -z "$CHOICES" ]; then
    declare -a options
    for CHOICE in $CHOICES; do
      case "$CHOICE" in
      "1")
        options+=( gdrive )
        ;;
      "2")
        options+=( gmail )
        ;;
      "3")
        options+=( goodreads )
        ;;
      "4")
        options+=( ldap )
        apt-get install -qqy libldap2-dev libsasl2-dev
        ;;
      "5")
        options+=( oauth )
        ;;
      "6")
        options+=( metadata )
        ;;
      "7")
        options+=( comics )
        ;;
      "8")
        options+=( kobo )
        ;;
      *)
        echo "Unsupported item $CHOICE!" >&2
        exit 1
        ;;
      esac
    done
  fi
  if [ ! -z "$options" ] && [ ${#options[@]} -gt 0 ]; then
    cps_options=$(IFS=, ; echo "${options[*]}")
    echo $cps_options > /opt/calibre-web/options.txt
    pip install --upgrade calibreweb[$cps_options]
  else
    rm /opt/calibre-web/options.txt 2> /dev/null
    pip install --upgrade calibreweb
  fi
  systemctl start cps
  msg_ok "Updated $APP LXC"
  exit
}

start
build_container
description

msg_info "Setting Container to Normal Resources"
pct set $CTID -memory 512
pct set $CTID -cores 1
msg_ok "Set Container to Normal Resources"
msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8083${CL} \n"
