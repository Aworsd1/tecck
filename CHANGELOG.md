<div align="center">
  <a href="#">
    <img src="https://raw.githubusercontent.com/tteck/Proxmox/main/misc/images/logo.png" height="100px" />
 </a>
</div>
<h1 align="center">Change Log</h1>

<h3 align="center">All notable changes to this project will be documented in this file.</h3>

- All LXC instances created using this repository come pre-installed with Midnight Commander, which is a command-line tool (`mc`) that offers a user-friendly file and directory management interface for the terminal environment.

## 2024-02-04

### Changed

- **Pi-hole LXC**
  - Option to add Unbound

## 2024-02-02

### Changed

- **Readeck LXC**
  - NEW Script

## 2024-01-25

### Changed

- **PairDrop LXC**
  - NEW Script

## 2024-01-20

### Changed

- **Apache-Cassandra LXC**
  - NEW Script
- **Redis LXC**
  - NEW Script

## 2024-01-17

### Changed

- **ntfy LXC**
  - NEW Script
- **HyperHDR LXC**
  - NEW Script

## 2024-01-16

### Changed

- **Website Improvements**
  - Refine and correct pointers.
  - Change hover colors to intuitively indicate categories/items.
  - Implement opening links in new tabs for better navigation.
  - Enhance the Copy button to better indicate that the command has been successfully copied.
  - Introduce a Clear Search button.
  - While not directly related to the website, it's worth mentioning that the logo in newly created LXC notes now serves as a link to the website, conveniently opening in a new tab.

## 2024-01-12

### Changed

- **Apt-Cacher-NG LXC**
  - NEW Script
- **New Feature**
  - The option to utilize Apt-Cacher-NG (Advanced settings) when creating LXCs. The added functionality is expected to decrease bandwidth usage and expedite package installation and updates. https://github.com/tteck/Proxmox/discussions/2332

## 2024-01-09

### Changed

- **Verbose mode**
  - Only entries with `$STD` will be shown

## 2024-01-07

### Changed

- **Stirling-PDF LXC**
  - NEW Script
- **SFTPGo LXC**
  - NEW Script

## 2024-01-04

### Changed

- **CommaFeed LXC**
  - NEW Script

## 2024-01-03

### Changed

- **Sonarr LXC**
  - Breaking Change
  - Complete recode
  - https://github.com/tteck/Proxmox/discussions/1738#discussioncomment-8005107

## 2024-01-01

### Changed

- **Gotify LXC**
  - NEW Script

## 2023-12-19

### Changed

- **Proxmox VE Netdata**
  - NEW Script

## 2023-12-10

### Changed

- **Homarr LXC**
  - Removed, again.

## 2023-12-02

### Changed

- **Runtipi LXC**
  - NEW Script

## 2023-12-01

### Changed

- **Mikrotik RouterOS VM**
  - Now Mikrotik RouterOS CHR VM
  - code refactoring
  - update to CHR
  - thanks to @NiccyB
- **Channels DVR Server LXC**
  - NEW Script

## 2023-11-19

### Changed

- **Dockge LXC**
  - NEW Script

## 2023-11-18

### Changed

- **Ubuntu 22.04 VM**
  - NEW Script

## 2023-11-14

### Changed

- **TurnKey Nextcloud VM**
  - NEW Script
- **TurnKey ownCloud VM**
  - NEW Script

## 2023-11-11

### Changed

- **Homarr LXC**
  - Returns with v0.14.0 (The authentication update).

## 2023-11-9

### Changed

- **AgentDVR LXC**
  - NEW Script

## 2023-11-8

### Changed

- **Linkwarden LXC**
  - NEW Script

## 2023-11-2

### Changed

- **PhotoPrism LXC**
  - Transitioned to PhotoPrism's latest installation package, featuring Linux binaries.

## 2023-11-1

### Changed

- **Owncast LXC**
  - NEW Script

## 2023-10-31

### Changed

- **Debian 12 VM**
  - NEW Script

## 2023-10-29

### Changed

- **Unmanic LXC**
  - NEW Script

## 2023-10-27

### Changed

- **Webmin**
  - A full code overhaul.

## 2023-10-15

### Changed

- **TasmoAdmin LXC**
  - NEW Script

## 2023-10-14

### Changed

- **Sonarr LXC**
  - Include an option to install v4 (experimental)

## 2023-10-11

### Changed

- **Proxmox VE CPU Scaling Governor**
  - A full code overhaul.
  - Include an option to configure a crontab for ensuring that the CPU Scaling Governor configuration persists across reboots.

## 2023-10-08

### Changed

- **Proxmox VE LXC Updater**
  - Now displays which containers require a reboot.
- **File Browser**
  - Uninstall by re-executing the script
  - Option to use No Authentication

## 2023-10-05

### Changed

- **Pingvin Share LXC**
  - NEW Script

## 2023-09-30

### Changed

- **All Templates**
  - NEW Script

## 2023-09-28

### Changed

- **Alpine Nextcloud Hub LXC**
  - NEW Script (Thanks to @nicedevil007)

## 2023-09-14

### Changed

- **Proxmox VE Processor Microcode**
  - Allow users to select available microcode packages.

## 2023-09-13

### Changed

- **Pi.Alert LXC**
  - NEW Script
- **Proxmox VE Kernel Clean**
  - Code overhaul with a fresh start. This script offers the flexibility to select specific kernels for removal, unlike the previous version, which was an all-or-nothing approach.

## 2023-09-11

### Changed

- **Paperless-ngx LXC**
  - Modify the script to incorporate Redis and PostgreSQL, while also introducing an option to include Adminer during installation.

## 2023-09-10

### Changed

- **TurnKey Game Server LXC**
  - NEW Script

## 2023-09-09

### Changed

- **Proxmox VE Host Backup**
  - Users are now able to specify both the backup path and the directory in which they wish to work.

## 2023-09-07

### Changed

- **Proxmox VE Host Backup**
  - NEW Script

## 2023-09-06

### Changed

- **Proxmox VE LXC Cleaner**
  - Added a new menu that allows you to choose which containers you want to exclude from the clean process.
- **Tailscale**
  - Added a menu that enables you to choose the specific container where you want to install Tailscale.

## 2023-09-05

### Changed

- **Proxmox VE LXC Updater**
  - Added a new menu that allows you to choose which containers you want to exclude from the update process.

## 2023-09-01

### Changed

- **TurnKey Media Server LXC**
  - NEW Script

## 2023-08-31

### Changed

- **TurnKey ZoneMinder LXC**
  - NEW Script
- **TurnKey OpenVPN LXC**
  - NEW Script

## 2023-08-30

### Changed

- **TurnKey**
  - Introducing a **NEW** Category on the Site.
  - My intention is to maintain the TurnKey scripts in their simplest form, contained within a single file, and with minimal options, if any.
- **TurnKey Core LXC**
  - NEW Script
- **TurnKey File Server LXC**
  - NEW Script
- **TurnKey Gitea LXC**
  - NEW Script
- **TurnKey GitLab LXC**
  - NEW Script
- **TurnKey Nextcloud LXC**
  - NEW Script
- **TurnKey Observium LXC**
  - NEW Script
- **TurnKey ownCloud LXC**
  - NEW Script
- **TurnKey Torrent Server LXC**
  - NEW Script
- **TurnKey Wordpress LXC**
  - NEW Script

## 2023-08-24

### Changed

- **qBittorrent LXC**
  - Added back to repository with UPnP disabled and password changed.

## 2023-08-24

### Changed

- **qBittorrent LXC**
  - Removed from this repository for potential malicious hidden code https://github.com/tteck/Proxmox/discussions/1725

## 2023-08-16

### Changed

- **Homarr LXC**
  - NEW Script

## 2023-08-10

### Changed

- **Proxmox VE Processor Microcode**
  - AMD microcode-20230808 Release

## 2023-08-09

### Changed

- **Omada Controller LXC**
  - Update via script
- **Proxmox VE Processor Microcode**
  - [Intel microcode-20230808 Release](https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/releases/tag/microcode-20230808)

## 2023-08-01

### Changed

- **Overseerr LXC**
  - NEW Script
- **Jellyseerr LXC**
  - NEW Script

## 2023-07-24

### Changed

- **Ombi LXC**
  - NEW Script

## 2023-07-23

### Changed

- **Zoraxy LXC**
  - NEW Script

## 2023-07-18

### Changed

- **Proxmox VE Cron LXC Updater**
  - NEW Script

## 2023-07-11

### Changed

- **Scrypted LXC**
  - Add VAAPI hardware transcoding

## 2023-07-07

### Changed

- **Real-Debrid Torrent Client LXC**
  - NEW Script

## 2023-07-05

### Changed

- There have been more than 110 commits since June 18th, although not all of them are significant, with a majority focused on ensuring compatibility with Proxmox VE 8 and Debian 12.

## 2023-06-18

### Changed

- **OpenObserve LXC**
  - NEW Script

## 2023-06-17

### Changed

- **UniFi Network Application LXC**
  - Now distribution agnostic.
- **Omada Controller LXC**
  - Now distribution agnostic.
## 2023-06-16

### Changed

- **Proxmox VE Monitor-All**
  - Skip instances based on onboot and templates. [8c2a3cc](https://github.com/tteck/Proxmox/commit/8c2a3cc4d774fa13d17f695d6bdf9a4deedb1372). 

## 2023-06-12

### Changed

- **Proxmox VE Edge Kernel**
  - Removed, with the Proxmox opt-in kernels and the upcoming Proxmox Virtual Environment 8, edge kernels are no longer needed.
- **Proxmox VE Kernel Clean**
  - Now compatible with PVE8.

## 2023-06-11

### Changed

- **Proxmox VE Post Install**
  - Now compatible with both Proxmox Virtual Environment 7 (PVE7) and Proxmox Virtual Environment 8 (PVE8). 

## 2023-06-02

### Changed

- **Proxmox VE 7 Post Install**
  - In a non-clustered environment, you can choose to disable high availability, which helps save system resources.

## 2023-05-27

### Changed

- **Proxmox VE 7 Post Install**
  - If an Intel N-series processor is detected, ~the script provides options to install both the Proxmox 6.2 kernel and the Intel microcode.~ and using PVE7, recommend using PVE8

## 2023-05-23

### Changed

- **OpenWrt VM**
  - NEW Script

## 2023-05-17

### Changed

- **Alpine-AdGuard Home LXC**
  - Removed, it wasn't installed through the Alpine package manager.
- **Alpine-Whoogle LXC**
  - Removed, it wasn't installed through the Alpine package manager.

## 2023-05-16

### Changed

- **Proxmox VE LXC Updater**
  - Add information about the boot disk, which provides an easy way to determine if you need to expand the disk.
- **Proxmox VE Processor Microcode**
  - [Intel microcode-20230512 Release](https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files/releases/tag/microcode-20230512)

## 2023-05-13

### Changed

- **Tautulli LXC**
  - NEW Script

## 2023-05-12

### Changed

- **Bazarr LXC**
  - NEW Script

## 2023-05-08

### Changed

- **Proxmox VE Intel Processor Microcode**
  - Renamed to **Proxmox VE Processor Microcode**
  - Automatically identifies the processor vendor (Intel/AMD) and installs the appropriate microcode.

## 2023-05-07

### Changed

- **FHEM LXC**
  - NEW Script

## 2023-05-01

### Changed

- **OctoPrint LXC**
  - NEW Script
- **Proxmox VE Intel Processor Microcode**
  - NEW Script

## 2023-04-30

### Changed

- **Proxmox VE Monitor-All**
  - NEW Script
  - Replaces Proxmox VE LXC Monitor

## 2023-04-28

### Changed

- **Proxmox VE LXC Monitor**
  - NEW Script

## 2023-04-26

### Changed

- **The site can now be accessed through a more memorable URL, which is [helper-scripts.com](http://helper-scripts.com).**

## 2023-04-23

### Changed

- **Non-Alpine LXC's**
  - Advanced settings provide the option for users to switch between Debian and Ubuntu distributions. However, some applications or services, such as Deconz, grocy or Omada, may not be compatible with the selected distribution due to dependencies.

## 2023-04-16

### Changed

- **Home Assistant Core LXC**
  - Python 3.11.2

## 2023-04-15

### Changed

- **InfluxDB LXC**
  - Choosing InfluxDB v1 will result in Chronograf being installed automatically.
- **[User Submitted Guides](https://github.com/tteck/Proxmox/blob/main/USER_SUBMITTED_GUIDES.md)**
  -  Informative guides that demonstrate how to install various software packages using Proxmox VE Helper Scripts.

## 2023-04-14

### Changed

- **Cloudflared LXC**
  - NEW Script

## 2023-04-05

### Changed

- **Jellyfin LXC**
  - Set Ubuntu 22.04 as default
  - Use the Deb822 format jellyfin.sources configuration (jellyfin.list configuration has been obsoleted)

## 2023-04-02

### Changed

- **Home Assistant OS VM**
  - Include a choice within the "Advanced" settings to configure the CPU model between kvm64 (default) or host.

## 2023-03-31

### Changed

- **Home Assistant OS VM**
  - Include a choice within the "Advanced" settings to configure the disk cache between none (default) or Write Through.

## 2023-03-27

### Changed

- **Removed Alpine-ESPHome LXC**
  - Nonoperational
- **All Scripts**
  - Incorporate code that examines whether SSH is being used and, if yes, offers a suggestion against it without restricting or blocking its usage.

## 2023-03-25

### Changed

- **Alpine-ESPHome LXC**
  - NEW Script
- **Alpine-Whoogle LXC**
  - NEW Script

## 2023-03-22

### Changed

- **The latest iteration of the scripts**
  - Going forward, versioning will no longer be utilized in order to avoid breaking web-links in blogs and YouTube videos.
  - The scripts have been made more legible as the repetitive code has been moved to function files, making it simpler to share among the scripts and hopefully easier to maintain. This also makes it simpler to contribute to the project.
  - When a container is created with privileged mode enabled, the USB passthrough feature is automatically activated.

## 2023-03-18

### Changed

- **Alpine-AdGuard Home LXC** (Thanks @nicedevil007)
  - NEW Script
- **Alpine-Docker LXC**
  - NEW Script
- **Alpine-Zigbee2MQTT LXC**
  - NEW Script

## 2023-03-15

### Changed

- **Alpine-Grafana LXC** (Thanks @nicedevil007)
  - NEW Script

## 2023-03-10

### Changed

- **Proxmox LXC Updater** 
  - You can use the command line to exclude multiple containers simultaneously.

## 2023-03-08

### Changed

- **Proxmox CPU Scaling Governor**
  - Menu options dynamically based on the available scaling governors.

## 2023-03-07

### Changed

- **Alpine-Vaultwarden LXC**
  - NEW Script
- **All LXC Scripts**
  - Retrieve the time zone from Proxmox and configure the container to use the same time zone

## 2023-02-24

### Changed

- **qBittorrent LXC** (Thanks @romka777)
  - NEW Script
- **Jackett LXC** (Thanks @romka777)
  - NEW Script

## 2023-02-23

### Changed

- **Proxmox LXC Updater** 
  - Skip all templates, allowing for the starting, updating, and shutting down of containers to be resumed automatically.
  - Exclude an additional container by adding the CTID at the end of the shell command ( -s 103).

## 2023-02-16

### Changed

- **RSTPtoWEB LXC** 
  - NEW Script
- **go2rtc LXC** 
  - NEW Script

## 2023-02-12

### Changed

- **OliveTin** 
  - NEW Script

## 2023-02-10

### Changed

- **Home Assistant OS VM** 
  - Code Refactoring

## 2023-02-05

### Changed

- **Devuan LXC** 
  - NEW Script

## 2023-02-02

### Changed

- **Audiobookshelf LXC** 
  - NEW Script
- **Rocky Linux LXC** 
  - NEW Script

## 2023-01-28

### Changed

- **LXC Cleaner** 
  - Code refactoring to give the user the option to choose whether cache or logs will be deleted for each app/service.
  - Leaves directory structure intact

## 2023-01-27

### Changed

- **LXC Cleaner** 
  - NEW Script

## 2023-01-26

### Changed

- **ALL LXC's** 
  - Add an option to disable IPv6 (Advanced)

## 2023-01-25

### Changed

- **Home Assistant OS VM** 
  - switch to v5
  - add an option to set MTU size (Advanced)
  - add arch check (no ARM64) (issue from community.home-assistant.io)
  - add check to insure VMID isn't already used before VM creation (Advanced) (issue from forum.proxmox.com)
  - code refactoring
- **PiMox Home Assistant OS VM** 
  - switch to v5
  - add an option to set MTU size (Advanced)
  - add arch check (no AMD64)
  - add pve check (=>7.2)
  - add check to insure VMID isn't already used before VM creation (Advanced)
  - code refactoring
- **All LXC's** 
  - add arch check (no ARM64) (issue from forum.proxmox.com)

## 2023-01-24

### Changed

- **Transmission LXC** 
  - NEW Script

## 2023-01-23

### Changed

- **ALL LXC's** 
  - Add [Midnight Commander (mc)](https://www.linuxcommand.org/lc3_adv_mc.php)

## 2023-01-22

### Changed

- **Autobrr LXC** 
  - NEW Script

## 2023-01-21

### Changed

- **Kavita LXC** 
  - NEW Script

## 2023-01-19

### Changed

- **SABnzbd LXC** 
  - NEW Script

## 2023-01-17

### Changed

- **Homer LXC** 
  - NEW Script

## 2023-01-14

### Changed

- **Tdarr LXC** 
  - NEW Script
- **Deluge LXC** 
  - NEW Script

## 2023-01-13

### Changed

- **Lidarr LXC** 
  - NEW Script
- **Prowlarr LXC** 
  - NEW Script
- **Radarr LXC** 
  - NEW Script
- **Readarr LXC** 
  - NEW Script
- **Sonarr LXC** 
  - NEW Script
- **Whisparr LXC** 
  - NEW Script

## 2023-01-12

### Changed

- **ALL LXC's** 
  - Add an option to set MTU size (Advanced)

## 2023-01-11

### Changed

- **Home Assistant Core LXC** 
  - Auto Initialize
- **Cronicle Primary/Worker LXC** 
  - NEW Script

## 2023-01-09

### Changed

- **ALL LXC's** 
  - v5
- **k0s Kubernetes LXC** 
  - NEW Script
- **Podman LXC** 
  - NEW Script

## 2023-01-04

### Changed

- **YunoHost LXC** 
  - NEW Script

## 2022-12-31

### Changed

- **v5 Scripts** (Testing before moving forward https://github.com/tteck/Proxmox/discussions/881)
  - Adguard Home LXC
  - Docker LXC
  - Home Assistant Core LXC
  - PhotoPrism LXC
  - Shinobi NVR LXC
  - Vaultwarden LXC

## 2022-12-27

### Changed

- **Home Assistant Container LXC** 
  - Add an option to use Fuse Overlayfs (ZFS) (Advanced)

- **Docker LXC** 
  - Add an option to use Fuse Overlayfs (ZFS) (Advanced)
  - If the LXC is created Privileged, the script will automatically set up USB passthrough.

## 2022-12-22

### Changed

- **All LXC's** 
  - Add an option to run the script in Verbose Mode (Advanced)

## 2022-12-20

### Changed

- **Hyperion LXC** 
  - NEW Script

## 2022-12-17

### Changed

- **Home Assistant Core LXC** 
  - Linux D-Bus Message Broker
  - Mariadb & PostgreSQL Ready
  - Bluetooth Ready
  - Fix for Inconsistent Dependency Versions (dbus-fast & bleak)

## 2022-12-16

### Changed

- **Home Assistant Core LXC** 
  - Python 3.10.8

## 2022-12-09

### Changed

- **Change Detection LXC** 
  - NEW Script

## 2022-12-03

### Changed

- **All LXC's** 
  - Add options to set DNS Server IP Address and DNS Search Domain (Advanced)

## 2022-11-27

### Changed

- **Shinobi LXC** 
  - NEW Script

## 2022-11-24

### Changed

- **Home Assistant OS VM** 
  - Add option to set machine type during VM creation (Advanced)

## 2022-11-23

### Changed

- **All LXC's** 
  - Add option to enable root ssh access during LXC creation (Advanced)

## 2022-11-21

### Changed

- **Proxmox LXC Updater** 
  - Now updates Ubuntu, Debian, Devuan, Alpine Linux, CentOS-Rocky-Alma, Fedora, ArchLinux [(@Uruknara)](https://github.com/tteck/Proxmox/commits?author=Uruknara)

## 2022-11-13

### Changed

- **All LXC's** 
  - Add option to continue upon Internet NOT Connected

## 2022-11-11

### Changed

- **HA Bluetooth Integration Preparation** 
  - [NEW Script](https://github.com/tteck/Proxmox/discussions/719)

## 2022-11-04

### Changed

- **Scrypted LXC** 
  - NEW Script

## 2022-11-01

### Changed

- **Alpine LXC** 
  - NEW Script
- **Arch LXC** 
  - NEW Script

## 2022-10-27

### Changed

- **Container & Core Restore from Backup** 
  - [NEW Scripts](https://github.com/tteck/Proxmox/discussions/674)

## 2022-10-07

### Changed

- **Home Assistant OS VM** 
  - Add "Latest" Image

## 2022-10-05

### Changed

- **Umbrel LXC** 
  - NEW Script (Docker)
- **Blocky LXC** 
  - NEW Script (Adblocker - DNS)

## 2022-09-29

### Changed

- **Home Assistant Container LXC** 
  - If the LXC is created Privileged, the script will automatically set up USB passthrough.
- **Home Assistant Core LXC** 
  - NEW Script
- **PiMox HAOS VM** 
  - NEW Script

## 2022-09-23

### Changed

- **EMQX LXC** 
  - NEW Script

## 2022-09-22

### Changed

- **NextCloudPi LXC** 
  - NEW Script

## 2022-09-21

### Changed

- **Proxmox Backup Server Post Install** 
  - NEW Script
- **Z-wave JS UI LXC** 
  - NEW Script (and all sub scripts 🤞)
- **Zwave2MQTT LXC** 
  - Bye Bye Script

## 2022-09-20

### Changed

- **OpenMediaVault LXC** 
  - NEW Script

## 2022-09-16

### Changed

- **Paperless-ngx LXC** 
  - NEW Script (Thanks @Donkeykong307)

## 2022-09-11

### Changed

- **Trilium LXC** 
  - NEW Script

## 2022-09-10

### Changed

- **Syncthing LXC** 
  - NEW Script

## 2022-09-09

### Changed

- **CasaOS LXC** 
  - NEW Script
- **Proxmox Kernel Clean** 
  - Now works with Proxmox Backup Server

## 2022-09-08

### Changed

- **Navidrome LXC** 
  - NEW Script
- **Homepage LXC** 
  - NEW Script

## 2022-08-31

### Changed

- **All LXC's** 
  - Add Internet & DNS Check

## 2022-08-22

### Changed

- **Wiki.js LXC** 
  - NEW Script
- **Emby Media Server LXC**
  - NEW Script

## 2022-08-20

### Changed

- **Mikrotik RouterOS VM** 
  - NEW Script

## 2022-08-19

### Changed

- **PhotoPrism LXC** 
  - Fixed .env bug (Thanks @cklam2)

## 2022-08-13

### Changed

- **Home Assistant OS VM** 
  - Option to create VM using Stable, Beta or Dev Image

## 2022-08-11

### Changed

- **Home Assistant OS VM** 
  - Validate Storage

## 2022-08-04

### Changed

- **VS Code Server** 
  - NEW Script

## 2022-08-02

### Changed

- **All LXC/VM** 
  - v4 Script - Whiptail menu's

## 2022-07-26

### Changed

- **Home Assistant OS VM** 
  - Set the real time clock (RTC) to local time.
  - Disable the USB tablet device (save resources / not needed).

## 2022-07-24

### Changed

- **Home Assistant OS VM** 
  - Present the drive to the guest as a solid-state drive rather than a rotational hard disk. There is no requirement that the underlying storage actually be backed by SSD's. 
  - When the VM’s filesystem marks blocks as unused after deleting files, the SCSI controller will relay this information to the storage, which will then shrink the disk image accordingly.
  - 👉 [more info](https://github.com/tteck/Proxmox/discussions/378)

## 2022-07-22

### Changed

- **n8n LXC** (thanks to @cyakimov)
  - NEW Script

## 2022-07-21

### Changed

- **grocy LXC**
  - NEW Script

## 2022-07-17

### Changed

- **Vaultwarden LXC**
  - NEW Vaultwarden Update (post 2022-05-29 installs only) Script
  - NEW Web-vault Update (any) Script

## 2022-07-14

### Changed

- **MagicMirror Server LXC**
  - NEW Script

## 2022-07-13

### Changed

- **Proxmox Edge Kernel Tool**
  - NEW Script

## 2022-07-11

### Changed

- **Home Assistant OS VM**
  - Supports lvmthin, zfspool, nfs, dir and btrfs storage types.

## 2022-07-08

### Changed

- **openHAB LXC**
  - NEW Script

## 2022-07-03

### Changed

- **Tailscale**
  - NEW Script

## 2022-07-01

### Changed

- **Home Assistant OS VM**
  - Allow different storage types (lvmthin, nfs, dir).

## 2022-06-30

### Changed

- **Prometheus LXC**
  - NEW Script

## 2022-06-06

### Changed

- **Whoogle LXC**
  - NEW Script

## 2022-05-29

### Changed

- **Vaultwarden LXC**
  - Code refactoring
- **CrowdSec**
  - NEW Script

## 2022-05-21

### Changed

- **Home Assistant OS VM**
  - Code refactoring

## 2022-05-19

### Changed

- **Keycloak LXC**
  - NEW Script

## 2022-05-18

### Changed

- **File Browser**
  - NEW Script

## 2022-05-13

### Changed

- **PostgreSQL LXC**
  - NEW Script

## 2022-05-10

### Changed

- **deCONZ LXC**
  - NEW Script

## 2022-05-07

### Changed

- **NocoDB LXC**
  - ADD update script

## 2022-05-06

### Changed

- **PhotoPrism LXC**
  - ADD GO Dependencies for full functionality

## 2022-05-05

### Changed

- **Ubuntu LXC**
  - ADD option to define version (18.04 20.04 21.10 22.04)

## 2022-04-28

### Changed

- **v3 Script**
  - Remove Internet Check

## 2022-04-27

### Changed

- **Home Assistant OS VM**
  - ADD Option to set Bridge, VLAN and MAC Address
- **v3 Script**
  - Improve Internet Check (prevent ‼ ERROR 4@57)

## 2022-04-26

### Changed

- **Home Assistant OS VM**
  - Fixed bad path
  - ADD Option to create VM using Latest or Stable image
- **UniFi Network Application LXC**
  - ADD Local Controller Option

## 2022-04-25

### Changed

- **v3 Script**
  - Improve Error Handling

## 2022-04-23

### Changed

- **v3 Script**
  - ADD Internet Connection Check
- **Proxmox VE 7 Post Install**
  - NEW v3 Script
- **Proxmox Kernel Clean**
  - NEW v3 Script

## 2022-04-22

### Changed

- **Omada Controller LXC**
  - Update script to install version 5.1.7
- **Uptime Kuma LXC**
  - ADD Update script

## 2022-04-20

### Changed

- **Ubuntu LXC**
  - ADD option to install version 20.04 or 21.10
- **v3 Script**
  - ADD option to set Bridge

## 2022-04-19

### Changed

- **ALL LXC's**
  - New [V3 Install Script](https://github.com/tteck/Proxmox/issues/162) 
- **ioBroker LXC**
  - New Script V3

## 2022-04-13

### Changed

- **Uptime Kuma LXC**
  - New Script V2

## 2022-04-11

### Changed

- **Proxmox LXC Updater**
  - ADD option to skip stopped containers
- **Proxmox VE 7 Post Install**
  - ADD PVE 7 check

## 2022-04-10

### Changed

- **Debian 11 LXC**
  - ADD An early look at the v3 install script

## 2022-04-09

### Changed

- **NocoDB LXC**
  - New Script V2

## 2022-04-05

### Changed

- **MeshCentral LXC**
  - New Script V2

## 2022-04-01

### Changed

- **Scripts** (V2)
  - FIX Pressing enter without making a selection first would cause an Error 

## 2022-03-28

### Changed

- **Docker LXC**
  - Add Docker Compose Option (@wovalle)

## 2022-03-27

### Changed

- **Heimdall Dashboard LXC**
  - New Update Script

## 2022-03-26

### Changed

- **UniFi Network Application LXC**
  - New Script V2
- **Omada Controller LXC**
  - New Script V2

## 2022-03-25

### Changed

- **Proxmox CPU Scaling Governor**
  - New Script


## 2022-03-24

### Changed

- **Plex Media Server LXC**
  - Switch to Ubuntu 20.04 to support HDR tone mapping
- **Docker LXC**
  - Add Portainer Option

## 2022-03-23

### Changed

- **Heimdall Dashboard LXC**
  - New Script V2

## 2022-03-20

### Changed

- **Scripts** (V2)
  - ADD choose between Automatic or Manual DHCP  

## 2022-03-18

### Changed

- **Technitium DNS LXC**
  - New Script V2
- **WireGuard LXC**
  - Add WGDashboard

## 2022-03-17

### Changed

- **Docker LXC**
  - New Script V2

## 2022-03-16

### Changed

- **PhotoPrism LXC**
  - New Update/Branch Script

## 2022-03-15

### Changed

- **Dashy LXC**
  - New Update Script

## 2022-03-14

### Changed

- **Zwavejs2MQTT LXC**
  - New Update Script

## 2022-03-12

### Changed

- **PhotoPrism LXC**
  - New Script V2

## 2022-03-11

### Changed

- **Vaultwarden LXC**
  - New V2 Install Script

## 2022-03-08

### Changed

- **Scripts** (V2)
  - Choose between Privileged or Unprivileged CT and Automatic or Password Login 
- **ESPHome LXC**
  - New V2 Install Script
- **Zwavejs2MQTT LXC**
  - New V2 Install Script
- **Motioneye LXC**
  - New V2 Install Script
- **Pihole LXC**
  - New V2 Install Script
- **GamUntu LXC**
  - New V2 Install Script

## 2022-03-06

### Changed

- **Zwavejs2MQTT LXC**
  - New GUI script to copy data from one Zwavejs2MQTT LXC to another Zwavejs2MQTT LXC

## 2022-03-05

### Changed

- **Homebridge LXC**
  - New Script V2

## 2022-03-04

### Changed

- **Proxmox Kernel Clean**
  - New Script

## 2022-03-03

### Changed

- **WireGuard LXC**
  - New Script V2

## 2022-03-02

### Changed

- **Proxmox LXC Updater**
  - New Script
- **Dashy LXC**
  - New Script V2
- **Grafana LXC**
  - New Script V2
- **InfluxDB/Telegraf LXC**
  - New Script V2

## 2022-03-01

### Changed

- **Daemon Sync Server LXC**
  - New Script V2

## 2022-02-28

### Changed

- **Vaultwarden LXC**
  - Add Update Script

## 2022-02-24

### Changed

- **Nginx Proxy Manager LXC**
  - New V2 Install Script

## 2022-02-23

### Changed

- **Adguard Home LXC**
  - New V2 Install Script
- **Zigbee2MQTT LXC**
  - New V2 Install Script
- **Home Assistant Container LXC**
  - Update Menu usability improvements

## 2022-02-22

### Changed

- **Home Assistant Container LXC**
  - New V2 Install Script
- **Node-Red LXC**
  - New V2 Install Script
- **Mariadb LXC**
  - New V2 Install Script
- **MQTT LXC**
  - New V2 Install Script
- **Debian 11 LXC**
  - New V2 Install Script
- **Ubuntu 21.10 LXC**
  - New V2 Install Script

## 2022-02-20

### Changed

- **Home Assistant Container LXC**
  - New Script to migrate to the latest Update Menu

## 2022-02-19

### Changed

- **Nginx Proxy Manager LXC**
  - Add Update Script
- **Vaultwarden LXC**
  - Make unattended install & Cleanup Script

## 2022-02-18

### Changed

- **Node-Red LXC**
  - Add Install [Themes Script](https://raw.githubusercontent.com/tteck/Proxmox/main/misc/images/node-red-themes.png)

## 2022-02-16

### Changed

- **Home Assistant Container LXC**
  - Add Options to [Update Menu](https://raw.githubusercontent.com/tteck/Proxmox/main/misc/images/update-menu.png)

## 2022-02-14

### Changed

- **Home Assistant Container LXC**
  - Add [Update Menu](https://raw.githubusercontent.com/tteck/Proxmox/main/misc/images/update-menu.png)

## 2022-02-13

### Changed

- **Mariadb LXC**
  - Add [Adminer](https://raw.githubusercontent.com/tteck/Proxmox/main/misc/images/adminer.png) (formerly phpMinAdmin), a full-featured database management tool

## 2022-02-12

### Changed

- **Home Assistant Container LXC (Podman)**
  - Add Yacht web interface for managing Podman containers
  - new GUI script to copy data from a **Home Assistant LXC** to a **Podman Home Assistant LXC**
  - Improve documentation for several LXC's

## 2022-02-10

### Changed

- **GamUntu LXC**
  - New Script
- **Jellyfin Media Server LXC**
  - new script to fix [start issue](https://github.com/tteck/Proxmox/issues/29#issue-1127457380)
- **MotionEye NVR LXC**
  - New script

## 2022-02-09

### Changed

- **Zigbee2MQTT LXC**
  - added USB passthrough during installation (no extra script)
  - Improve documentation
- **Zwavejs2MQTT LXC**
  - added USB passthrough during installation (no extra script)
- **Jellyfin Media Server LXC**
  - Moved to testing due to issues. 
  - Changed install method.
- **Home Assistant Container LXC (Podman)** 
  - add script for easy Home Assistant update

## 2022-02-06

### Changed

- **Debian 11 LXC**
  - Add Docker Support
- **Ubuntu 21.10 LXC**
  - Add Docker Support

## 2022-02-05

### Changed

- **Vaultwarden LXC**
  - New script

## 2022-02-01

### Changed

- **All Scripts**
  - Fix issue where some networks were slow to assign a IP address to the container causing scripts to fail.

## 2022-01-30

### Changed

- **Zigbee2MQTT LXC**
  - Clean up / Improve script
  - Improve documentation

## 2022-01-29

### Changed

- **Node-Red LXC**
  - Clean up / Improve script
  - Improve documentation

## 2022-01-25

### Changed

- **Jellyfin Media Server LXC**
  - new script

## 2022-01-24

### Changed

- **Plex Media Server LXC**
  - better Hardware Acceleration Support
  - `va-driver-all` is preinstalled
  - now using Ubuntu 21.10
- **misc**
  - new GUI script [(Screenshot)](https://raw.githubusercontent.com/tteck/Proxmox/main/misc/images/pms-copy-data.png) to copy data from one Plex Media Server LXC to another Plex Media Server LXC 


## Initial Catch up - 2022-01-23
 
### Changed

- **Plex Media Server LXC**
  - add Hardware Acceleration Support
  - add script to install Intel Drivers
- **Zwavejs2MQTT LXC**
  - new script to solve no auto start at boot
- **Nginx Proxy Manager LXC** 
  - new script to use Debian 11
- **Ubuntu 21.10 LXC** 
  - new script
- **Mariadb LXC** 
  - add MariaDB Package Repository
- **MQTT LXC** 
  - add Eclipse Mosquitto Package Repository
- **Home Assistant Container LXC** 
  - change if ZFS filesystem is detected, execute automatic installation of static fuse-overlayfs
  - add script for easy Home Assistant update
- **Home Assistant Container LXC (Podman)** 
  - change if ZFS filesystem is detected, execute automatic installation of static fuse-overlayfs
- **Home Assistant OS VM** 
  - change disk type from SATA to SCSI to follow Proxmox official recommendations of choosing VirtIO-SCSI with SCSI disk
  - clean up
- **Proxmox VE 7 Post Install** 
  - new *No-Nag* method
- **misc**
  - new GUI script to copy data from one Home Assistant LXC to another Home Assistant LXC
  - new GUI script to copy data from one Zigbee2MQTT LXC to another Zigbee2MQTT LXC
