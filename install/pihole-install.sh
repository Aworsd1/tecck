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
$STD apt-get install -y ufw
$STD apt-get install -y ntp
msg_ok "Installed Dependencies"

msg_info "Installing Pi-hole"
mkdir -p /etc/pihole/
cat <<EOF >/etc/pihole/setupVars.conf
PIHOLE_INTERFACE=eth0
PIHOLE_DNS_1=8.8.8.8
PIHOLE_DNS_2=8.8.4.4
QUERY_LOGGING=true
INSTALL_WEB_SERVER=true
INSTALL_WEB_INTERFACE=true
LIGHTTPD_ENABLED=true
CACHE_SIZE=10000
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSMASQ_LISTENING=local
WEBPASSWORD=$(openssl rand -base64 48)
BLOCKING_ENABLED=true
EOF
# View script https://install.pi-hole.net
$STD bash <(curl -fsSL https://install.pi-hole.net) --unattended
msg_ok "Installed Pi-hole"

read -r -p "Would you like to add Unbound? <y/N> " prompt
if [[ ${prompt,,} =~ ^(y|yes)$ ]]; then
  msg_info "Installing Unbound"
  $STD apt-get install -y unbound
  cat <<EOF >/etc/unbound/unbound.conf.d/pi-hole.conf
server:
  verbosity: 0
  interface: 0.0.0.0
  port: 5335
  do-ip6: no
  do-ip4: yes
  do-udp: yes
  do-tcp: yes
  num-threads: 1
  hide-identity: yes
  hide-version: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  harden-referral-path: yes
  use-caps-for-id: no
  harden-algo-downgrade: no
  qname-minimisation: yes
  aggressive-nsec: yes
  rrset-roundrobin: yes
  cache-min-ttl: 300
  cache-max-ttl: 14400
  msg-cache-slabs: 8
  rrset-cache-slabs: 8
  infra-cache-slabs: 8
  key-cache-slabs: 8
  serve-expired: yes
  serve-expired-ttl: 3600
  edns-buffer-size: 1232
  prefetch: yes
  prefetch-key: yes
  target-fetch-policy: "3 2 1 1 1"
  unwanted-reply-threshold: 10000000
  rrset-cache-size: 256m
  msg-cache-size: 128m
  so-rcvbuf: 1m
  private-address: 192.168.0.0/16
  private-address: 169.254.0.0/16
  private-address: 172.16.0.0/12
  private-address: 10.0.0.0/8
  private-address: fd00::/8
  private-address: fe80::/10
EOF
  mkdir -p /etc/dnsmasq.d/
  cat <<EOF >/etc/dnsmasq.d/99-edns.conf
edns-packet-max=1232
EOF
  wget -q https://www.internic.net/domain/named.root >/var/lib/unbound/root.hints
  sed -i -e 's/PIHOLE_DNS_1=8.8.8.8/PIHOLE_DNS_1=127.0.0.1#5335/' -e 's/PIHOLE_DNS_2=8.8.4.4/#PIHOLE_DNS_2=8.8.4.4/' /etc/pihole/setupVars.conf
  systemctl enable -q --now unbound
  systemctl restart pihole-FTL.service
  msg_ok "Installed Unbound"
fi

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
