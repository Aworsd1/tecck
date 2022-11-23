#!/usr/bin/env bash
AVX=$(grep -o -m1 'avx[^ ]*' /proc/cpuinfo)
YW=$(echo "\033[33m")
RD=$(echo "\033[01;31m")
BL=$(echo "\033[36m")
GN=$(echo "\033[1;92m")
CL=$(echo "\033[m")
RETRY_NUM=10
RETRY_EVERY=3
NUM=$RETRY_NUM
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"
BFR="\\r\\033[K"
HOLD="-"
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
shopt -s expand_aliases
alias die='EXIT=$? LINE=$LINENO error_exit'
trap die ERR

function error_exit() {
  trap - ERR
  local reason="Unknown failure occurred."
  local msg="${1:-$reason}"
  local flag="${RD}‼ ERROR ${CL}$EXIT@$LINE"
  echo -e "$flag $msg" 1>&2
  exit $EXIT
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
while [ "$(hostname -I)" = "" ]; do
  echo 1>&2 -en "${CROSS}${RD} No Network! "
  sleep $RETRY_EVERY
  ((NUM--))
  if [ $NUM -eq 0 ]; then
    echo 1>&2 -e "${CROSS}${RD} No Network After $RETRY_NUM Tries${CL}"
    exit 1
  fi
done
msg_ok "Set up Container OS"
msg_ok "Network Connected: ${BL}$(hostname -I)"

set +e
alias die=''
if nc -zw1 8.8.8.8 443; then msg_ok "Internet Connected"; else
  msg_error "Internet NOT Connected"
    read -r -p "Would you like to continue anyway? <y/N> " prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then
      echo -e " ⚠️  ${RD}Expect Issues Without Internet${CL}"
    else
      echo -e " 🖧  Check Network Settings"
      exit 1
    fi
fi
RESOLVEDIP=$(nslookup "github.com" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
if [[ -z "$RESOLVEDIP" ]]; then msg_error "DNS Lookup Failure"; else msg_ok "DNS Resolved github.com to $RESOLVEDIP"; fi
alias die='EXIT=$? LINE=$LINENO error_exit'
set -e

msg_info "Updating Container OS"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated Container OS"

msg_info "Installing Dependencies (Patience)"
apt-get install -y curl &>/dev/null
apt-get install -y sudo &>/dev/null
apt-get install -y gcc &>/dev/null
apt-get install -y g++ &>/dev/null
apt-get install -y git &>/dev/null
apt-get install -y gnupg &>/dev/null
apt-get install -y make &>/dev/null
apt-get install -y zip &>/dev/null
apt-get install -y unzip &>/dev/null
apt-get install -y exiftool &>/dev/null
apt-get install -y ffmpeg &>/dev/null
msg_ok "Installed Dependencies"

msg_info "Setting up Node.js Repository"
curl -sL https://deb.nodesource.com/setup_18.x | bash - &>/dev/null
msg_ok "Set up Node.js Repository"

msg_info "Installing Node.js"
apt-get install -y nodejs &>/dev/null
msg_ok "Installed Node.js"

msg_info "Installing Golang (Patience)"
wget https://golang.org/dl/go1.19.3.linux-amd64.tar.gz &>/dev/null
tar -xzf go1.19.3.linux-amd64.tar.gz -C /usr/local &>/dev/null
ln -s /usr/local/go/bin/go /usr/local/bin/go &>/dev/null
go install github.com/tianon/gosu@latest &>/dev/null
go install golang.org/x/tools/cmd/goimports@latest &>/dev/null
go install github.com/psampaz/go-mod-outdated@latest &>/dev/null
go install github.com/dsoprea/go-exif/v3/command/exif-read-tool@latest &>/dev/null
go install github.com/mikefarah/yq/v4@latest &>/dev/null
go install github.com/kyoh86/richgo@latest &>/dev/null
cp /root/go/bin/* /usr/local/go/bin/
cp /usr/local/go/bin/richgo /usr/local/bin/richgo
cp /usr/local/go/bin/gosu /usr/local/sbin/gosu
chown root:root /usr/local/sbin/gosu
chmod 755 /usr/local/sbin/gosu
msg_ok "Installed Golang"

msg_info "Installing Tensorflow"
if [[ "$AVX" =~ avx2 ]]; then
  wget https://dl.photoprism.org/tensorflow/linux/libtensorflow-linux-avx2-1.15.2.tar.gz &>/dev/null
  tar -C /usr/local -xzf libtensorflow-linux-avx2-1.15.2.tar.gz &>/dev/null
elif [[ "$AVX" =~ avx ]]; then
  wget https://dl.photoprism.org/tensorflow/linux/libtensorflow-linux-avx-1.15.2.tar.gz &>/dev/null
  tar -C /usr/local -xzf libtensorflow-linux-avx-1.15.2.tar.gz &>/dev/null
else
  wget https://dl.photoprism.org/tensorflow/linux/libtensorflow-linux-cpu-1.15.2.tar.gz &>/dev/null
  tar -C /usr/local -xzf libtensorflow-linux-cpu-1.15.2.tar.gz &>/dev/null
fi
ldconfig &>/dev/null
msg_ok "Installed Tensorflow"

msg_info "Cloning PhotoPrism"
mkdir -p /opt/photoprism/bin
mkdir -p /var/lib/photoprism/storage
git clone https://github.com/photoprism/photoprism.git &>/dev/null
cd photoprism
git checkout release &>/dev/null
msg_ok "Cloned PhotoPrism"

msg_info "Building PhotoPrism (Patience)"
NODE_OPTIONS=--max_old_space_size=2048 make all &>/dev/null
./scripts/build.sh prod /opt/photoprism/bin/photoprism &>/dev/null
cp -r assets/ /opt/photoprism/ &>/dev/null
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

PASS=$(grep -w "root" /etc/shadow | cut -b6)
if [[ $PASS != $ ]]; then
  msg_info "Customizing Container"
  rm /etc/motd
  rm /etc/update-motd.d/10-uname
  touch ~/.hushlogin
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
if [[ "${SSH_ROOT}" == "yes" ]]; then
    cat <<EOF >>/etc/ssh/sshd_config
PermitRootLogin yes
EOF
systemctl restart sshd
fi

msg_info "Cleaning up"
apt-get autoremove >/dev/null
apt-get autoclean >/dev/null
rm -rf /var/{cache,log}/* \
  /photoprism \
  /go1.19.3.linux-amd64.tar.gz \
  /libtensorflow-linux-avx2-1.15.2.tar.gz \
  /libtensorflow-linux-avx-1.15.2.tar.gz \
  /libtensorflow-linux-cpu-1.15.2.tar.gz
msg_ok "Cleaned"

msg_info "Starting PhotoPrism"
systemctl enable --now photoprism &>/dev/null
