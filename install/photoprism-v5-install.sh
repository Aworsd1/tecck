#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

if [ "$VERBOSE" = "yes" ]; then set -x; STD=""; else STD="silent"; fi
silent() { "$@" > /dev/null 2>&1; }
if [ "$DISABLEIPV6" == "yes" ]; then echo "net.ipv6.conf.all.disable_ipv6 = 1" >>/etc/sysctl.conf; $STD sysctl -p; fi
YW=$(echo "\033[33m")
RD=$(echo "\033[01;31m")
BL=$(echo "\033[36m")
GN=$(echo "\033[1;92m")
CL=$(echo "\033[m")
RETRY_NUM=10
RETRY_EVERY=3
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"
BFR="\\r\\033[K"
HOLD="-"
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

msg_info "Setting up Container OS "
sed -i "/$LANG/ s/\(^# \)//" /etc/locale.gen
locale-gen >/dev/null
echo $tz > /etc/timezone
ln -sf /usr/share/zoneinfo/$tz /etc/localtime
for ((i=RETRY_NUM; i>0; i--)); do
  if [ "$(hostname -I)" != "" ]; then
    break
  fi
  echo 1>&2 -en "${CROSS}${RD} No Network! "
  sleep $RETRY_EVERY
done
if [ "$(hostname -I)" = "" ]; then
  echo 1>&2 -e "\n${CROSS}${RD} No Network After $RETRY_NUM Tries${CL}"
  echo -e " 🖧  Check Network Settings"
  exit 1
fi
msg_ok "Set up Container OS"
msg_ok "Network Connected: ${BL}$(hostname -I)"

set +e
trap - ERR
if ping -c 1 -W 1 1.1.1.1 &> /dev/null; then msg_ok "Internet Connected"; else
  msg_error "Internet NOT Connected"
    read -r -p "Would you like to continue anyway? <y/N> " prompt
    if [[ "${prompt,,}" =~ ^(y|yes)$ ]]; then
      echo -e " ⚠️  ${RD}Expect Issues Without Internet${CL}"
    else
      echo -e " 🖧  Check Network Settings"
      exit 1
    fi
fi
RESOLVEDIP=$(getent hosts github.com | awk '{ print $1 }')
if [[ -z "$RESOLVEDIP" ]]; then msg_error "DNS Lookup Failure"; else msg_ok "DNS Resolved github.com to ${BL}$RESOLVEDIP${CL}"; fi
set -e
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

msg_info "Updating Container OS"
$STD apt-get update
$STD apt-get -y upgrade
msg_ok "Updated Container OS"

msg_info "Installing Dependencies (Patience)"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y gcc
$STD apt-get install -y g++
$STD apt-get install -y git
$STD apt-get install -y gnupg
$STD apt-get install -y make
$STD apt-get install -y zip
$STD apt-get install -y unzip
$STD apt-get install -y exiftool
$STD apt-get install -y ffmpeg
msg_ok "Installed Dependencies"

msg_info "Setting up Node.js Repository"
$STD bash <(curl -fsSL https://deb.nodesource.com/setup_18.x)
msg_ok "Set up Node.js Repository"

msg_info "Installing Node.js"
$STD apt-get -y install nodejs
msg_ok "Installed Node.js"

msg_info "Installing Golang"
set +o pipefail
RELEASE=$(curl -s https://go.dev/dl/ | grep -o "go.*\linux-amd64.tar.gz" | head -n 1)
wget -q https://golang.org/dl/$RELEASE
$STD tar -xzf $RELEASE -C /usr/local
$STD ln -s /usr/local/go/bin/go /usr/local/bin/go
msg_ok "Installed Golang"

msg_info "Installing Go Dependencies"
$STD go install github.com/tianon/gosu@latest
$STD go install golang.org/x/tools/cmd/goimports@latest
$STD go install github.com/psampaz/go-mod-outdated@latest
$STD go install github.com/dsoprea/go-exif/v3/command/exif-read-tool@latest
$STD go install github.com/mikefarah/yq/v4@latest
$STD go install github.com/kyoh86/richgo@latest
cp /root/go/bin/* /usr/local/go/bin/
cp /usr/local/go/bin/richgo /usr/local/bin/richgo
cp /usr/local/go/bin/gosu /usr/local/sbin/gosu
chown root:root /usr/local/sbin/gosu
chmod 755 /usr/local/sbin/gosu
msg_ok "Installed Go Dependencies"

msg_info "Installing Tensorflow"
if grep -q avx2 /proc/cpuinfo; then
  suffix="avx2-"
elif grep -q avx /proc/cpuinfo; then
  suffix="avx-"
else
  suffix="1"
fi
version=$(curl -s https://dl.photoprism.org/tensorflow/amd64/ | grep -o "libtensorflow-amd64-$suffix.*\\.tar.gz" | head -n 1)
wget -q https://dl.photoprism.org/tensorflow/amd64/$version
tar -C /usr/local -xzf $version
ldconfig
set -o pipefail
msg_ok "Installed Tensorflow"

msg_info "Cloning PhotoPrism"
mkdir -p /opt/photoprism/bin
mkdir -p /var/lib/photoprism/storage
$STD git clone https://github.com/photoprism/photoprism.git
cd photoprism
$STD git checkout release
msg_ok "Cloned PhotoPrism"

msg_info "Building PhotoPrism (Patience)"
$STD make -B
$STD ./scripts/build.sh prod /opt/photoprism/bin/photoprism
$STD cp -r assets/ /opt/photoprism/
msg_ok "Built PhotoPrism"

env_path="/var/lib/photoprism/.env"
echo " 
PHOTOPRISM_AUTH_MODE='password'
PHOTOPRISM_ADMIN_PASSWORD='changeme'
PHOTOPRISM_HTTP_HOST='0.0.0.0'
PHOTOPRISM_HTTP_PORT='2342'
PHOTOPRISM_SITE_CAPTION='https://tteck.github.io/Proxmox/'
PHOTOPRISM_STORAGE_PATH='/var/lib/photoprism/storage'
PHOTOPRISM_ORIGINALS_PATH='/var/lib/photoprism/photos/Originals'
PHOTOPRISM_IMPORT_PATH='/var/lib/photoprism/photos/Import'
" >$env_path

msg_info "Creating Service"
service_path="/etc/systemd/system/photoprism.service"

echo "[Unit]
Description=PhotoPrism service
After=network.target

[Service]
Type=forking
User=root
WorkingDirectory=/opt/photoprism
EnvironmentFile=/var/lib/photoprism/.env
ExecStart=/opt/photoprism/bin/photoprism up -d
ExecStop=/opt/photoprism/bin/photoprism down

[Install]
WantedBy=multi-user.target" >$service_path
msg_ok "Created Service"

echo "export TERM='xterm-256color'" >>/root/.bashrc
echo -e "$APPLICATION LXC provided by https://tteck.github.io/Proxmox/\n" > /etc/motd
chmod -x /etc/update-motd.d/*
if ! getent shadow root | grep -q "^root:[^\!*]"; then
  msg_info "Customizing Container"
  GETTY_OVERRIDE="/etc/systemd/system/container-getty@1.service.d/override.conf"
  mkdir -p $(dirname $GETTY_OVERRIDE)
  cat <<EOF >$GETTY_OVERRIDE
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear --keep-baud tty%I 115200,38400,9600 \$TERM
EOF
  systemctl daemon-reload
  systemctl restart $(basename $(dirname $GETTY_OVERRIDE) | sed 's/\.d//')
  msg_ok "Customized Container"
fi
if [[ "${SSH_ROOT}" == "yes" ]]; then sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config; systemctl restart sshd; fi

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
rm -rf /var/{cache,log}/* \
  /photoprism \
  /$RELEASE \
  /$version
msg_ok "Cleaned"

msg_info "Starting PhotoPrism"
systemctl enable -q --now photoprism
msg_ok "Started PhotoPrism"
