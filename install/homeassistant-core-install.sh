#!/usr/bin/env bash
if [ "$VERBOSE" == "yes" ]; then set -x; fi
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
apt-get install -y \
  make \
  build-essential \
  libjpeg-dev \
  libpcap-dev \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libmariadb-dev-compat \
  autoconf \
  git \
  curl \
  sudo \
  llvm \
  libncursesw5-dev \
  xz-utils \
  tzdata \
  bluez \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  libopenjp2-7 \
  libtiff5 \
  libturbojpeg0-dev \
  liblzma-dev &>/dev/null
msg_ok "Installed Dependencies"

msg_info "Installing Linux D-Bus Message Broker"
cat <<EOF >>/etc/apt/sources.list
deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian bullseye-backports main contrib non-free
EOF
apt-get update &>/dev/null
apt-get -t bullseye-backports install -y dbus-broker &>/dev/null
systemctl enable --now dbus-broker.service &>/dev/null
msg_ok "Installed Linux D-Bus Message Broker"

msg_info "Installing pyenv"
git clone https://github.com/pyenv/pyenv.git ~/.pyenv &>/dev/null
set +e
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init --path)"\nfi' >> ~/.bashrc  
msg_ok "Installed pyenv"
. ~/.bashrc
set -e
msg_info "Installing Python 3.10.8"
pyenv install 3.10.8 &>/dev/null
pyenv global 3.10.8
msg_ok "Installed Python 3.10.8"

read -r -p "  Use the Beta Branch? <y/N> " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then
  BR="--pre "
else
  BR=""
fi

msg_info "Installing Home Assistant-Core"
mkdir /srv/homeassistant
cd /srv/homeassistant
python3 -m venv .
source bin/activate
pip install --upgrade pip &>/dev/null
python3 -m pip install wheel &>/dev/null
pip install mysqlclient &>/dev/null
pip install psycopg2-binary &>/dev/null
pip install ${BR}homeassistant &>/dev/null
msg_ok "Installed Home Assistant-Core"

# fix for inconsistent versions, hopefully the HA team will get this fixed
if [ "${BR}" == "--pre " ]; then
sed -i '{s/dbus-fast==1.82.0/dbus-fast==1.83.1/g; s/bleak==0.19.2/bleak==0.19.5/g}' /srv/homeassistant/lib/python3.10/site-packages/homeassistant/package_constraints.txt
sed -i '{s/dbus-fast==1.82.0/dbus-fast==1.83.1/g; s/bleak==0.19.2/bleak==0.19.5/g}' /srv/homeassistant/lib/python3.10/site-packages/homeassistant/components/bluetooth/manifest.json
else
sed -i '{s/dbus-fast==1.75.0/dbus-fast==1.83.1/g; s/bleak==0.19.2/bleak==0.19.5/g}' /srv/homeassistant/lib/python3.10/site-packages/homeassistant/package_constraints.txt
sed -i '{s/dbus-fast==1.75.0/dbus-fast==1.83.1/g; s/bleak==0.19.2/bleak==0.19.5/g}' /srv/homeassistant/lib/python3.10/site-packages/homeassistant/components/bluetooth/manifest.json
fi

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/homeassistant.service
[Unit]
Description=Home Assistant
After=network-online.target
[Service]
Type=simple
WorkingDirectory=/root/.homeassistant
ExecStart=/srv/homeassistant/bin/hass -c "/root/.homeassistant"
RestartForceExitStatus=100
[Install]
WantedBy=multi-user.target
EOF
systemctl enable homeassistant &>/dev/null
msg_ok "Created Service"

PASS=$(grep -w "root" /etc/shadow | cut -b6)
if [[ $PASS != $ ]]; then
  msg_info "Customizing Container"
  chmod -x /etc/update-motd.d/*
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
  sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
  systemctl restart sshd
fi

msg_info "Cleaning up"
apt-get autoremove >/dev/null
apt-get autoclean >/dev/null
msg_ok "Cleaned"
