#!/usr/bin/env bash
# Use to copy all data from a Zwavejs2MQTT LXC to a Z-wave JS UI LXC
# run from the Proxmox Shell
# bash -c "$(wget -qLO - https://raw.githubusercontent.com/tteck/Proxmox/main/misc/zwave-copy-data.sh)"
while true; do
  read -p "Use to copy all data from a Zwavejs2MQTT LXC to a Z-wave JS UI LXC. Proceed(y/n)?" yn
  case $yn in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo "Please answer yes or no." ;;
  esac
done
clear
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
shopt -s expand_aliases
alias die='EXIT=$? LINE=$LINENO error_exit'
trap die ERR
trap cleanup EXIT

function error_exit() {
  trap - ERR
  local DEFAULT='Unknown failure occured.'
  local REASON="\e[97m${1:-$DEFAULT}\e[39m"
  local FLAG="\e[91m[ERROR] \e[93m$EXIT@$LINE"
  msg "$FLAG $REASON"
  exit $EXIT
}
function warn() {
  local REASON="\e[97m$1\e[39m"
  local FLAG="\e[93m[WARNING]\e[39m"
  msg "$FLAG $REASON"
}
function info() {
  local REASON="$1"
  local FLAG="\e[36m[INFO]\e[39m"
  msg "$FLAG $REASON"
}
function msg() {
  local TEXT="$1"
  echo -e "$TEXT"
}
function cleanup() {
  [ -d "${CTID_FROM_PATH:-}" ] && pct unmount $CTID_FROM
  [ -d "${CTID_TO_PATH:-}" ] && pct unmount $CTID_TO
  popd >/dev/null
  rm -rf $TEMP_DIR
}
TEMP_DIR=$(mktemp -d)
pushd $TEMP_DIR >/dev/null

TITLE="Zigbee2MQTT to Z-wave JS UI Data Copy"
while read -r line; do
  TAG=$(echo "$line" | awk '{print $1}')
  ITEM=$(echo "$line" | awk '{print substr($0,36)}')
  OFFSET=2
  if [[ $((${#ITEM} + $OFFSET)) -gt ${MSG_MAX_LENGTH:-} ]]; then
    MSG_MAX_LENGTH=$((${#ITEM} + $OFFSET))
  fi
  CTID_MENU+=("$TAG" "$ITEM " "OFF")
done < <(pct list | awk 'NR>1')
while [ -z "${CTID_FROM:+x}" ]; do
  CTID_FROM=$(whiptail --title "$TITLE" --radiolist \
    "\nWhich Zwavejs2MQTT LXC would you like to copy FROM?\n" \
    16 $(($MSG_MAX_LENGTH + 23)) 6 \
    "${CTID_MENU[@]}" 3>&1 1>&2 2>&3) || exit
done
while [ -z "${CTID_TO:+x}" ]; do
  CTID_TO=$(whiptail --title "$TITLE" --radiolist \
    "\nWhich Z-wave JS UI LXC would you like to copy TO?\n" \
    16 $(($MSG_MAX_LENGTH + 23)) 6 \
    "${CTID_MENU[@]}" 3>&1 1>&2 2>&3) || exit
done
for i in ${!CTID_MENU[@]}; do
  [ "${CTID_MENU[$i]}" == "$CTID_FROM" ] &&
    CTID_FROM_HOSTNAME=$(sed 's/[[:space:]]*$//' <<<${CTID_MENU[$i + 1]})
  [ "${CTID_MENU[$i]}" == "$CTID_TO" ] &&
    CTID_TO_HOSTNAME=$(sed 's/[[:space:]]*$//' <<<${CTID_MENU[$i + 1]})
done
whiptail --defaultno --title "$TITLE" --yesno \
  "Are you sure you want to copy data between the following LXCs?
$CTID_FROM (${CTID_FROM_HOSTNAME}) -> $CTID_TO (${CTID_TO_HOSTNAME})
Version: 2022.09.21" 13 50 || exit
info "Zwavejs2MQTT Data from '$CTID_FROM' to '$CTID_TO'"
if [ $(pct status $CTID_TO | sed 's/.* //') == 'running' ]; then
  msg "Stopping '$CTID_TO'..."
  pct stop $CTID_TO
fi
msg "Mounting Container Disks..."
DATA_PATH=/opt/zwavejs2mqtt/store/
DATA_PATH_NEW=/opt/zwave-js-ui/store/
CTID_FROM_PATH=$(pct mount $CTID_FROM | sed -n "s/.*'\(.*\)'/\1/p") ||
  die "There was a problem mounting the root disk of LXC '${CTID_FROM}'."
[ -d "${CTID_FROM_PATH}${DATA_PATH}" ] ||
  die "Zwavejs2MQTT directories in '$CTID_FROM' not found."
CTID_TO_PATH=$(pct mount $CTID_TO | sed -n "s/.*'\(.*\)'/\1/p") ||
  die "There was a problem mounting the root disk of LXC '${CTID_TO}'."
[ -d "${CTID_TO_PATH}${DATA_PATH_NEW}" ] ||
  die "Zwavejs2MQTT directories in '$CTID_TO' not found."

#rm -rf ${CTID_TO_PATH}${DATA_PATH}
#mkdir ${CTID_TO_PATH}${DATA_PATH}

msg "Copying Data Between Containers..."
RSYNC_OPTIONS=(
  --archive
  --hard-links
  --sparse
  --xattrs
  --no-inc-recursive
  --info=progress2
)
msg "<======== Zwavejs Data ========>"
rsync ${RSYNC_OPTIONS[*]} ${CTID_FROM_PATH}${DATA_PATH} ${CTID_TO_PATH}${DATA_PATH_NEW}
echo -en "\e[1A\e[0K\e[1A\e[0K"

info "Successfully Transferred Data."
