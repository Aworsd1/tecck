#!/usr/bin/env bash

# Copyright (c) 2021-2023 tteck
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
$STD apt-get install -y git
msg_ok "Installed Dependencies"

msg_info "Installing Node.js"
$STD bash <(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh)
. ~/.bashrc
$STD nvm install 16.20.1
ln -sf /root/.nvm/versions/node/v16.20.1/bin/node /usr/bin/node
msg_ok "Installed Node.js"

msg_info "Setting up MagicMirror Repository"
$STD git clone https://github.com/MichMich/MagicMirror /opt/magicmirror
msg_ok "Set up MagicMirror Repository"

msg_info "Installing MagicMirror"
cd /opt/magicmirror
$STD npm install --only=prod --omit=dev

cat <<EOF >/opt/magicmirror/config/config.js
let config = {
        address: "0.0.0.0",     
        port: 8080,
        basePath: "/",  
        ipWhitelist: [],        
        useHttps: false,              
        httpsPrivateKey: "",    
        httpsCertificate: "",   
        language: "en",
        locale: "en-US",
        logLevel: ["INFO", "LOG", "WARN", "ERROR"], 
        timeFormat: 24,
        units: "metric",
        serverOnly:  true,
        modules: [
                {
                        module: "alert",
                },
                {
                        module: "updatenotification",
                        position: "top_bar"
                },
                {
                        module: "clock",
                        position: "top_left"
                },
                {
                        module: "calendar",
                        header: "US Holidays",
                        position: "top_left",
                        config: {
                                calendars: [
                                        {
                                                symbol: "calendar-check",
                                                url: "webcal://www.calendarlabs.com/ical-calendar/ics/76/US_Holidays.ics"
                                        }
                                ]
                        }
                },
                {
                        module: "compliments",
                        position: "lower_third"
                },
                {
                        module: "weather",
                        position: "top_right",
                        config: {
                                weatherProvider: "openweathermap",
                                type: "current",
                                location: "New York",
                                locationID: "5128581", //ID from http://bulk.openweathermap.org/sample/city.list.json.gz; unzip the gz file and find your city
                                apiKey: "YOUR_OPENWEATHER_API_KEY"
                        }
                },
                {
                        module: "weather",
                        position: "top_right",
                        header: "Weather Forecast",
                        config: {
                                weatherProvider: "openweathermap",
                                type: "forecast",
                                location: "New York",
                                locationID: "5128581", //ID from http://bulk.openweathermap.org/sample/city.list.json.gz; unzip the gz file and find your city
                                apiKey: "YOUR_OPENWEATHER_API_KEY"
                        }
                },
                {
                        module: "newsfeed",
                        position: "bottom_bar",
                        config: {
                                feeds: [
                                        {
                                                title: "New York Times",
                                                url: "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
                                        }
                                ],
                                showSourceTitle: true,
                                showPublishDate: true,
                                broadcastNewsFeeds: true,
                                broadcastNewsUpdates: true
                        }
                },
        ]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {module.exports = config;}
EOF
msg_ok "Installed MagicMirror"

msg_info "Creating Service"
service_path="/etc/systemd/system/magicmirror.service"
echo "[Unit]
Description=Magic Mirror
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
WorkingDirectory=/opt/magicmirror/
ExecStart=/usr/bin/node serveronly

[Install]
WantedBy=multi-user.target" >$service_path
$STD systemctl enable --now magicmirror
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get autoremove
$STD apt-get autoclean
msg_ok "Cleaned"
