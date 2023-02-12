#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"

    _       ____             __            
   (_)___  / __ )_________  / /_____  _____
  / / __ \/ __  / ___/ __ \/ //_/ _ \/ ___/
 / / /_/ / /_/ / /  / /_/ / ,< /  __/ /    
/_/\____/_____/_/ v5\____/_/|_|\___/_/     
 
EOF
}
header_info
echo -e "Loading..."
APP="ioBroker"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="11"
NSAPP=$(echo ${APP,,} | tr -d ' ')
var_install="${NSAPP}-v5-install"
INTEGER='^[0-9]+$'
YW=$(echo "\033[33m")
BL=$(echo "\033[36m")
RD=$(echo "\033[01;31m")
BGN=$(echo "\033[4;92m")
GN=$(echo "\033[1;92m")
DGN=$(echo "\033[32m")
CL=$(echo "\033[m")
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"
set -Eeuo pipefail
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR
function error_handler() {
  local exit_code="$?"
  local line_number="$1"
  local command="$2"
  local error_message="${RD}[ERROR]${CL} in line ${RD}$line_number${CL}: exit code ${RD}$exit_code${CL}: while executing command ${YW}$command${CL}"
  echo -e "\n$error_message\n"
}

function msg_info() {
  local msg="$1"
  echo -ne " ${HOLD} ${YW}${msg}..."
}

function msg_ok() {
  local msg="$1"
  echo -e "${BFR} ${CM} ${GN}${msg}${CL}"
}

function msg_error() {
  local msg="$1"
  echo -e "${BFR} ${CROSS} ${RD}${msg}${CL}"
}

function PVE_CHECK() {
if [ $(pveversion | grep -c "pve-manager/7\.[0-9]") -eq 0 ]; then
  echo -e "${CROSS} This version of Proxmox Virtual Environment is not supported"
  echo -e "Requires PVE Version 7.0 or higher"
  echo -e "Exiting..."
  sleep 2
exit
fi
}
function ARCH_CHECK() {
if [ "$(dpkg --print-architecture)" != "amd64" ]; then
  echo -e "\n ${CROSS} This script will not work with PiMox! \n"
  echo -e "Exiting..."
  sleep 2
exit
fi
}

function default_settings() {
  echo -e "${DGN}Using Container Type: ${BGN}Unprivileged${CL} ${RD}NO DEVICE PASSTHROUGH${CL}"
  CT_TYPE="1"
  echo -e "${DGN}Using Root Password: ${BGN}Automatic Login${CL}"
  PW=""
  echo -e "${DGN}Using Container ID: ${BGN}$NEXTID${CL}"
  CT_ID=$NEXTID
  echo -e "${DGN}Using Hostname: ${BGN}$NSAPP${CL}"
  HN=$NSAPP
  echo -e "${DGN}Using Disk Size: ${BGN}$var_disk${CL}${DGN}GB${CL}"
  DISK_SIZE="$var_disk"
  echo -e "${DGN}Allocated Cores ${BGN}$var_cpu${CL}"
  CORE_COUNT="$var_cpu"
  echo -e "${DGN}Allocated Ram ${BGN}$var_ram${CL}"
  RAM_SIZE="$var_ram"
  echo -e "${DGN}Using Bridge: ${BGN}vmbr0${CL}"
  BRG="vmbr0"
  echo -e "${DGN}Using Static IP Address: ${BGN}dhcp${CL}"
  NET=dhcp
  echo -e "${DGN}Using Gateway Address: ${BGN}Default${CL}"
  GATE=""
  echo -e "${DGN}Disable IPv6: ${BGN}No${CL}"
  DISABLEIP6="no"
  echo -e "${DGN}Using Interface MTU Size: ${BGN}Default${CL}"
  MTU=""
  echo -e "${DGN}Using DNS Search Domain: ${BGN}Host${CL}"
  SD=""
  echo -e "${DGN}Using DNS Server Address: ${BGN}Host${CL}"
  NS=""
  echo -e "${DGN}Using MAC Address: ${BGN}Default${CL}"
  MAC=""
  echo -e "${DGN}Using VLAN Tag: ${BGN}Default${CL}"
  VLAN=""
  echo -e "${DGN}Enable Root SSH Access: ${BGN}No${CL}"
  SSH="no"
  echo -e "${DGN}Enable Verbose Mode: ${BGN}No${CL}"
  VERB="no"
  echo -e "${BL}Creating a ${APP} LXC using the above default settings${CL}"
}
function advanced_settings() {
  CT_TYPE=$(whiptail --title "CONTAINER TYPE" --radiolist --cancel-button Exit-Script "Choose Type" 10 58 2 \
    "1" "Unprivileged" ON \
    "0" "Privileged" OFF \
    3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    echo -e "${DGN}Using Container Type: ${BGN}$CT_TYPE${CL}"
  fi
  PW1=$(whiptail --inputbox "Set Root Password (needed for root ssh access)" 8 58 --title "PASSWORD(leave blank for automatic login)" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    if [ -z $PW1 ]; then
      PW1="Automatic Login" PW=" "
      echo -e "${DGN}Using Root Password: ${BGN}$PW1${CL}"
    else
      PW="-password $PW1"
      echo -e "${DGN}Using Root Password: ${BGN}$PW1${CL}"
    fi
  fi
  CT_ID=$(whiptail --inputbox "Set Container ID" 8 58 $NEXTID --title "CONTAINER ID" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ -z $CT_ID ]; then
    CT_ID="$NEXTID"
    echo -e "${DGN}Container ID: ${BGN}$CT_ID${CL}"
  else
    if [ $exitstatus = 0 ]; then echo -e "${DGN}Using Container ID: ${BGN}$CT_ID${CL}"; fi
  fi
  CT_NAME=$(whiptail --inputbox "Set Hostname" 8 58 $NSAPP --title "HOSTNAME" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ -z $CT_NAME ]; then
    HN="$NSAPP"
    echo -e "${DGN}Using Hostname: ${BGN}$HN${CL}"
  else
    if [ $exitstatus = 0 ]; then
      HN=$(echo ${CT_NAME,,} | tr -d ' ')
      echo -e "${DGN}Using Hostname: ${BGN}$HN${CL}"
    fi
  fi
  DISK_SIZE=$(whiptail --inputbox "Set Disk Size in GB" 8 58 $var_disk --title "DISK SIZE" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ -z $DISK_SIZE ]; then
    DISK_SIZE="$var_disk"
    echo -e "${DGN}Using Disk Size: ${BGN}$DISK_SIZE${CL}"
  else
    if [ $exitstatus = 0 ]; then echo -e "${DGN}Using Disk Size: ${BGN}$DISK_SIZE${CL}"; fi
    if ! [[ $DISK_SIZE =~ $INTEGER ]]; then
      echo -e "${RD}⚠ DISK SIZE MUST BE A INTEGER NUMBER!${CL}"
      advanced_settings
    fi
  fi
  CORE_COUNT=$(whiptail --inputbox "Allocate CPU Cores" 8 58 $var_cpu --title "CORE COUNT" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ -z $CORE_COUNT ]; then
    CORE_COUNT="$var_cpu"
    echo -e "${DGN}Allocated Cores: ${BGN}$CORE_COUNT${CL}"
  else
    if [ $exitstatus = 0 ]; then echo -e "${DGN}Allocated Cores: ${BGN}$CORE_COUNT${CL}"; fi
  fi
  RAM_SIZE=$(whiptail --inputbox "Allocate RAM in MiB" 8 58 $var_ram --title "RAM" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ -z $RAM_SIZE ]; then
    RAM_SIZE="$var_ram"
    echo -e "${DGN}Allocated RAM: ${BGN}$RAM_SIZE${CL}"
  else
    if [ $exitstatus = 0 ]; then echo -e "${DGN}Allocated RAM: ${BGN}$RAM_SIZE${CL}"; fi
  fi
  BRG=$(whiptail --inputbox "Set a Bridge" 8 58 vmbr0 --title "BRIDGE" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ -z $BRG ]; then
    BRG="vmbr0"
    echo -e "${DGN}Using Bridge: ${BGN}$BRG${CL}"
  else
    if [ $exitstatus = 0 ]; then echo -e "${DGN}Using Bridge: ${BGN}$BRG${CL}"; fi
  fi
  NET=$(whiptail --inputbox "Set a Static IPv4 CIDR Address(/24)" 8 58 dhcp --title "IP ADDRESS" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ -z $NET ]; then
    NET="dhcp"
    echo -e "${DGN}Using IP Address: ${BGN}$NET${CL}"
  else
    if [ $exitstatus = 0 ]; then echo -e "${DGN}Using IP Address: ${BGN}$NET${CL}"; fi
  fi
  GATE1=$(whiptail --inputbox "Set a Gateway IP (mandatory if Static IP was used)" 8 58 --title "GATEWAY IP" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    if [ -z $GATE1 ]; then
      GATE1="Default" GATE=""
      echo -e "${DGN}Using Gateway IP Address: ${BGN}$GATE1${CL}"
    else
      GATE=",gw=$GATE1"
      echo -e "${DGN}Using Gateway IP Address: ${BGN}$GATE1${CL}"
    fi
  fi
  if (whiptail --defaultno --title "IPv6" --yesno "Disable IPv6?" 10 58); then
      echo -e "${DGN}Disable IPv6: ${BGN}Yes${CL}"
      DISABLEIP6="yes"
  else
      echo -e "${DGN}Disable IPv6: ${BGN}No${CL}"
      DISABLEIP6="no"
  fi
  MTU1=$(whiptail --inputbox "Set Interface MTU Size (leave blank for default)" 8 58 --title "MTU SIZE" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    if [ -z $MTU1 ]; then
      MTU1="Default" MTU=""
      echo -e "${DGN}Using Interface MTU Size: ${BGN}$MTU1${CL}"
    else
      MTU=",mtu=$MTU1"
      echo -e "${DGN}Using Interface MTU Size: ${BGN}$MTU1${CL}"
    fi
  fi
  SD=$(whiptail --inputbox "Set a DNS Search Domain (leave blank for HOST)" 8 58 --title "DNS Search Domain" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    if [ -z $SD ]; then
      SD=""
      echo -e "${DGN}Using DNS Search Domain: ${BGN}Host${CL}"
    else
      SX=$SD
      SD="-searchdomain=$SD"
      echo -e "${DGN}Using DNS Search Domain: ${BGN}$SX${CL}"
    fi
  fi
  NS=$(whiptail --inputbox "Set a DNS Server IP (leave blank for HOST)" 8 58 --title "DNS SERVER IP" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    if [ -z $NS ]; then
      NS=""
      echo -e "${DGN}Using DNS Server IP Address: ${BGN}Host${CL}"
    else
      NX=$NS
      NS="-nameserver=$NS"
      echo -e "${DGN}Using DNS Server IP Address: ${BGN}$NX${CL}"
    fi
  fi
  MAC1=$(whiptail --inputbox "Set a MAC Address(leave blank for default)" 8 58 --title "MAC ADDRESS" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    if [ -z $MAC1 ]; then
      MAC1="Default" MAC=""
      echo -e "${DGN}Using MAC Address: ${BGN}$MAC1${CL}"
    else
      MAC=",hwaddr=$MAC1"
      echo -e "${DGN}Using MAC Address: ${BGN}$MAC1${CL}"
    fi
  fi
  VLAN1=$(whiptail --inputbox "Set a Vlan(leave blank for default)" 8 58 --title "VLAN" --cancel-button Exit-Script 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    if [ -z $VLAN1 ]; then
      VLAN1="Default" VLAN=""
      echo -e "${DGN}Using Vlan: ${BGN}$VLAN1${CL}"
    else
      VLAN=",tag=$VLAN1"
      echo -e "${DGN}Using Vlan: ${BGN}$VLAN1${CL}"
    fi
  fi
  if (whiptail --defaultno --title "SSH ACCESS" --yesno "Enable Root SSH Access?" 10 58); then
      echo -e "${DGN}Enable Root SSH Access: ${BGN}Yes${CL}"
      SSH="yes"
  else
      echo -e "${DGN}Enable Root SSH Access: ${BGN}No${CL}"
      SSH="no"
  fi
  if (whiptail --defaultno --title "VERBOSE MODE" --yesno "Enable Verbose Mode?" 10 58); then
      echo -e "${DGN}Enable Verbose Mode: ${BGN}Yes${CL}"
      VERB="yes"
  else
      echo -e "${DGN}Enable Verbose Mode: ${BGN}No${CL}"
      VERB="no"
  fi
  if (whiptail --title "ADVANCED SETTINGS COMPLETE" --yesno "Ready to create ${APP} LXC?" --no-button Do-Over 10 58); then
    echo -e "${RD}Creating a ${APP} LXC using the above advanced settings${CL}"
  else
    clear
    header_info
    echo -e "${RD}Using Advanced Settings${CL}"
    advanced_settings
  fi
}
function install_script() {
ARCH_CHECK
PVE_CHECK
NEXTID=$(pvesh get /cluster/nextid)
header_info
  if (whiptail --title "SETTINGS" --yesno "Use Default Settings?" --no-button Advanced 10 58); then
    header_info
    echo -e "${BL}Using Default Settings${CL}"
    default_settings
  else
    header_info
    echo -e "${RD}Using Advanced Settings${CL}"
    advanced_settings
  fi
}

function update_script() {
header_info
msg_info "Updating ${APP} LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated ${APP} LXC"
msg_ok "Update Successfull"
exit
}

if command -v pveversion >/dev/null 2>&1; then
  if ! (whiptail --title "${APP} LXC" --yesno "This will create a New ${APP} LXC. Proceed?" 10 58); then
    clear
    echo -e "⚠  User exited script \n"
    exit
  fi
  install_script
fi

if ! command -v pveversion >/dev/null 2>&1 && [[ ! -d /opt/iobroker ]]; then
  msg_error "No ${APP} Installation Found!"
  exit 
fi

if ! command -v pveversion >/dev/null 2>&1; then
  if ! (whiptail --title "${APP} LXC UPDATE" --yesno "This will update ${APP} LXC.  Proceed?" 10 58); then
    clear
    echo -e "⚠  User exited script \n"
    exit
  fi
  update_script
fi

if [ "$VERB" == "yes" ]; then set -x; fi
if [ "$CT_TYPE" == "1" ]; then
  FEATURES="nesting=1,keyctl=1"
else
  FEATURES="nesting=1"
fi
TEMP_DIR=$(mktemp -d)
pushd $TEMP_DIR >/dev/null
export DISABLEIPV6=$DISABLEIP6
export APPLICATION=$APP
export VERBOSE=$VERB
export SSH_ROOT=${SSH}
export CTID=$CT_ID
export PCT_OSTYPE=$var_os
export PCT_OSVERSION=$var_version
export PCT_DISK_SIZE=$DISK_SIZE
export PCT_OPTIONS="
  -features $FEATURES
  -hostname $HN
  $SD
  $NS
  -net0 name=eth0,bridge=$BRG$MAC,ip=$NET$GATE$VLAN$MTU
  -onboot 1
  -cores $CORE_COUNT
  -memory $RAM_SIZE
  -unprivileged $CT_TYPE
  $PW
"
bash -c "$(wget -qLO - https://raw.githubusercontent.com/tteck/Proxmox/main/ct/create_lxc.sh)" || exit
msg_info "Starting LXC Container"
pct start $CTID
msg_ok "Started LXC Container"
lxc-attach -n $CTID -- bash -c "$(wget -qLO - https://raw.githubusercontent.com/tteck/Proxmox/main/install/$var_install.sh)" || exit
IP=$(pct exec $CTID ip a s dev eth0 | awk '/inet / {print $2}' | cut -d/ -f1)
pct set $CTID -description "# ${APP} LXC
### https://tteck.github.io/Proxmox/
<a href='https://ko-fi.com/D1D7EP4GF'><img src='https://img.shields.io/badge/☕-Buy me a coffee-red' /></a>"
msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8081${CL} \n"
