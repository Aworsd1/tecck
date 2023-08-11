#!/usr/bin/env bash
# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ____                                               __  ____                                __
   / __ \_________  ________  ______________  _____   /  |/  (_)_____________  _________  ____/ /__
  / /_/ / ___/ __ \/ ___/ _ \/ ___/ ___/ __ \/ ___/  / /|_/ / / ___/ ___/ __ \/ ___/ __ \/ __  / _ \
 / ____/ /  / /_/ / /__/  __(__  |__  ) /_/ / /     / /  / / / /__/ /  / /_/ / /__/ /_/ / /_/ /  __/
/_/   /_/   \____/\___/\___/____/____/\____/_/     /_/  /_/_/\___/_/   \____/\___/\____/\__,_/\___/

EOF
}

RD=$(echo "\033[01;31m")
YW=$(echo "\033[33m")
GN=$(echo "\033[1;92m")
CL=$(echo "\033[m")
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"

set -euo pipefail
shopt -s inherit_errexit nullglob

msg_info() {
  local msg="$1"
  echo -ne " ${HOLD} ${YW}${msg}..."
}

msg_ok() {
  local msg="$1"
  echo -e "${BFR} ${CM} ${GN}${msg}${CL}"
}

msg_error() {
  local msg="$1"
  echo -e "${BFR} ${CROSS} ${RD}${msg}${CL}"
}

header_info
current_microcode=$(dmesg | grep -o 'microcode updated early to revision [^,]*, date = [0-9\-]*')
while true; do
  if [ -z "${current_microcode}" ]; then
    msg_error "Microcode update information not found."
  else
    msg_ok "Current ${current_microcode}"
  fi
  read -p "Install the latest Processor Microcode (y/n)?" yn
  case $yn in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo "Please answer yes or no." ;;
  esac
done
header_info

intel() {
  if ! apt -qq list --installed iucode-tool >/dev/null 2>&1; then
    msg_info "Installing iucode-tool: a tool for updating Intel processor microcode"
    apt-get install -y iucode-tool &>/dev/null
    msg_ok "Installed iucode-tool"
  else
    msg_ok "Intel iucode-tool is already installed"
  fi
  
  msg_info "Downloading the latest Intel Processor Microcode Package for Linux"
  wget -q http://ftp.debian.org/debian/pool/non-free-firmware/i/intel-microcode/intel-microcode_3.20230808.1_amd64.deb
  msg_ok "Downloaded the latest Intel Processor Microcode Package"

  msg_info "Installing the Intel Processor Microcode (Patience)"
  dpkg -i intel-microcode_3.20230808.1_amd64.deb &>/dev/null
  msg_ok "Installed the Intel Processor Microcode"

  msg_info "Cleaning up"
  rm intel-microcode_3.20230808.1_amd64.deb
  msg_ok "Cleaned"
  
  echo -e "\n To apply the changes, the system will need to be rebooted.\n"
}

amd() {
  msg_info "Downloading the latest AMD Processor Microcode Package for Linux"
  wget -q http://ftp.debian.org/debian/pool/non-free-firmware/a/amd64-microcode/amd64-microcode_3.20230808.1.1_amd64.deb
  msg_ok "Downloaded the latest AMD Processor Microcode Package"

  msg_info "Installing the AMD Processor Microcode (Patience)"
  dpkg -i amd64-microcode_3.20230808.1.1_amd64.deb &>/dev/null
  msg_ok "Installed the AMD Processor Microcode"

  msg_info "Cleaning up"
  rm amd64-microcode_3.20230808.1.1_amd64.deb
  msg_ok "Cleaned"
  
  echo -e "\n To apply the changes, the system will need to be rebooted.\n"
}

if ! command -v pveversion >/dev/null 2>&1; then
  header_info
  msg_error "\n No PVE Detected!\n"
  exit
fi
msg_info "Checking CPU Vendor"
cpu=$(lscpu | grep -oP 'Vendor ID:\s*\K\S+' | head -n 1)
if [ "$cpu" == "GenuineIntel" ]; then
  msg_ok "${cpu} was detected"
  intel
elif [ "$cpu" == "AuthenticAMD" ]; then
  msg_ok "${cpu} was detected"
  amd
else
  msg_error "${cpu} is not supported"
  exit
fi
