#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

# bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/edge-kernel.sh)"
function header_info {
cat <<"EOF"
    ____ _    ________   ______    __              __ __                     __    
   / __ \ |  / / ____/  / ____/___/ /___ ____     / //_/__  _________  ___  / /____
  / /_/ / | / / __/    / __/ / __  / __ `/ _ \   / ,< / _ \/ ___/ __ \/ _ \/ / ___/
 / ____/| |/ / /___   / /___/ /_/ / /_/ /  __/  / /| /  __/ /  / / / /  __/ (__  ) 
/_/     |___/_____/  /_____/\__,_/\__, /\___/  /_/ |_\___/_/  /_/ /_/\___/_/____/  
                                 /____/                                            
 
EOF
}
set -e
KERNEL_ON=$(uname -r)
PVE_KERNEL=$(dpkg --list | grep 'kernel-.*-pve' | awk '{print substr($2, 12, length($2)-1) }' | tac | head -n 1)
EDGE_KERNEL=$(dpkg --list | grep 'kernel-.*-edge' | awk '{print substr($2, 12, length($2)-1) }' | tac | head -n 1)
VER=$(curl -s https://api.github.com/repos/fabianishere/pve-edge-kernel/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-9) }')
KER=$(curl -s https://api.github.com/repos/fabianishere/pve-edge-kernel/releases/latest | grep "tag_name" | awk '{print substr($2, 3, length($2)-6) }')
clear
header_info
while true; do
    read -p "This is a Proxmox Edge Kernel Tool, USE AT YOUR OWN RISK. Proceed(y/n)?" yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) exit ;;
    *) echo "Please answer yes or no." ;;
    esac
done
clear
header_info
show_menu() {
    normal=$(echo "\033[m")
    safe=$(echo "\033[32m")
    menu=$(echo "\033[36m")
    number=$(echo "\033[33m")
    bgred=$(echo "\033[41m")
    fgred=$(echo "\033[31m")
    proxmox-boot-tool kernel list
    echo -e "\nCurrent Kernel: ${menu}${KERNEL_ON}${normal}"
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${normal} Install Proxmox Edge Kernel ${menu}${KER}${normal} & Reboot\n"
    printf "${menu}**${number} 2)${normal} Switch to Proxmox VE 7 ${menu}${PVE_KERNEL}${normal} Kernel & Reboot\n"
    printf "${menu}**${number} 3)${normal} Switch to Proxmox Edge ${menu}${EDGE_KERNEL}${normal} Kernel & Reboot\n"
    printf "${menu}**${number} 4)${normal} Unpin Current Kernel\n"
    printf "${menu}**${number} 5)${normal} Remove All Current ${menu}${VER}*${normal} Proxmox Edge Kernels & Reboot\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please choose an option from the menu, or ${fgred}x${normal} to exit."
    read opt
}
option_picked() {
    msgcolor=$(echo "\033[01;31m")
    normal=$(echo "\033[00;00m")
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}
clear
header_info
show_menu
while [ "$opt" != "" ]; do
    if [ "$opt" = "" ]; then
        exit
    else
        case $opt in
        1)
            while true; do
                read -p "Are you sure you want to Install Proxmox Edge Kernel & Reboot? Proceed(y/n)?" yn
                case $yn in
                [Yy]*) break ;;
                [Nn]*) exit ;;
                *) echo "Please answer yes or no." ;;
                esac
            done
            clear
            option_picked "Installing Proxmox Edge Kernel & Rebooting"
            apt-get install -y gnupg
            curl -1sLf 'https://dl.cloudsmith.io/public/pve-edge/kernel/gpg.8EC01CCF309B98E7.key' | apt-key add -
            echo "deb https://dl.cloudsmith.io/public/pve-edge/kernel/deb/debian bullseye main" >/etc/apt/sources.list.d/pve-edge-kernel.list
            apt-get -y update
            apt-get -y install pve-kernel-${VER}-edge
            reboot
            break
            ;;
        2)
            while true; do
                read -p "Are you sure you want to Switch to Proxmox VE 7 ${PVE_KERNEL} Kernel & Reboot? Proceed(y/n)?" yn
                case $yn in
                [Yy]*) break ;;
                [Nn]*) exit ;;
                *) echo "Please answer yes or no." ;;
                esac
            done
            clear
            option_picked "Switching to Proxmox VE 7 Kernel & Rebooting"
            proxmox-boot-tool kernel pin ${PVE_KERNEL}
            reboot
            break
            ;;
        3)
            while true; do
                read -p "Are you sure you want to Switch to Proxmox ${EDGE_KERNEL} Edge Kernel & Reboot? Proceed(y/n)?" yn
                case $yn in
                [Yy]*) break ;;
                [Nn]*) exit ;;
                *) echo "Please answer yes or no." ;;
                esac
            done
            clear
            option_picked "Switching to Proxmox Edge Kernel & Rebooting"
            proxmox-boot-tool kernel pin ${EDGE_KERNEL}
            reboot
            break
            ;;
        4)
            while true; do
                read -p "Are you sure you want to Unpin the Current Kernel? Proceed(y/n)?" yn
                case $yn in
                [Yy]*) break ;;
                [Nn]*) exit ;;
                *) echo "Please answer yes or no." ;;
                esac
            done
            clear
            option_picked "Unpinning Current Kernel"
            proxmox-boot-tool kernel unpin
            clear
            break
            ;;
        5)
            while true; do
                read -p "Are you sure you want to Remove Proxmox Edge Kernel & Reboot? Proceed(y/n)?" yn
                case $yn in
                [Yy]*) break ;;
                [Nn]*) exit ;;
                *) echo "Please answer yes or no." ;;
                esac
            done
            clear
            option_picked "Removing Proxmox Edge Kernel & Rebooting"
            apt --purge remove -y pve-kernel-${VER}*edge pve-headers-${VER}*edge
            rm -rf /etc/apt/sources.list.d/pve-edge-kernel.list
            proxmox-boot-tool kernel unpin
            reboot
            break
            ;;
        x)
            exit
            ;;
        \n)
            exit
            ;;
        *)
            clear
            option_picked "Please choose an option from the menu"
            header_info
            show_menu
            ;;
        esac
    fi
done
header_info
show_menu
