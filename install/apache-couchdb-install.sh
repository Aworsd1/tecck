#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y apt-transport-https
$STD apt-get install -y gnupg
msg_ok "Installed Dependencies"

msg_info "Installing Apache CouchDB"
ERLANG_COOKIE=$(openssl rand -base64 32)
ADMIN_PASS="$(openssl rand -base64 18 | cut -c1-13)"
debconf-set-selections <<< "couchdb couchdb/cookie string $ERLANG_COOKIE"
debconf-set-selections <<< "couchdb couchdb/mode select standalone"
debconf-set-selections <<< "couchdb couchdb/bindaddress string 0.0.0.0"
debconf-set-selections <<< "couchdb couchdb/adminpass password $ADMIN_PASS"
debconf-set-selections <<< "couchdb couchdb/adminpass_again password $ADMIN_PASS"
curl -fsSL https://couchdb.apache.org/repo/keys.asc | gpg --dearmor -o /usr/share/keyrings/couchdb-archive-keyring.gpg
VERSION_CODENAME="$(awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release)"
echo "deb [signed-by=/usr/share/keyrings/couchdb-archive-keyring.gpg] https://apache.jfrog.io/artifactory/couchdb-deb/ ${VERSION_CODENAME} main" >/etc/apt/sources.list.d/couchdb.sources.list
$STD apt-get update
$STD apt-get install -y couchdb
echo -e "CouchDB Erlang Cookie: \e[32m$ERLANG_COOKIE\e[0m" >>~/CouchDB.creds
echo -e "CouchDB Admin Password: \e[32m$ADMIN_PASS\e[0m" >>~/CouchDB.creds
msg_ok "Installed Apache CouchDB."

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
