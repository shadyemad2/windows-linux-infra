# 🖥️ Hybrid Infrastructure Lab (Windows + Linux)
This project is a **practical lab environment** built on VMware to simulate a small company IT infrastructure. It integrates **Windows Server (AD, DNS, DHCP, File Share)**, **Linux Server (Web, DB, Backup, Bash Scripts)**, and a **Windows 10 Client**.

## 📌 Project Components
| VM              | Role(s)                                 | Example IP      |
|-----------------|-----------------------------------------|----------------|
| Windows Server  | AD + DNS + DHCP + File Shares           | 192.168.213.20 |
| Linux Server    | Web/App + Database + Backup Scripts     | 192.168.213.21 |
| Windows 10      | Domain Client (Employee/User)           | 192.168.213.40 |

## ⚙️ Step 1 – Environment Setup
- VMware Workstation / Player
- ISOs:
  - Windows Server 2019/2022
  - Ubuntu Server (or CentOS/RHEL)
  - Windows 10 Pro
- Network: **Host-Only/Internal** (all VMs in the same LAN)

## ⚙️ Step 2 – Windows Server
- Static IP: `192.168.213.20`
- Install & Configure:
  - **Active Directory Domain Services (AD DS)**
  - **DNS Server**
  - **DHCP Server**
- Domain: `shady.local`
- OUs: `hr`, `it`, `Sales`
- Users & Groups per department
- Shared Folders: `\\192.168.213.20\hr-folder`, `\\192.168.213.20\it-folder`, `\\192.168.213.20\sales-folder`

## ⚙️ Step 3 – Windows 10 Client
- Static/DHCP IP: `192.168.213.40`
- Join Domain `shady.local`
- Login using AD user account
- Access shared folders from Windows Server

## ⚙️ Step 4 – Linux Server
- Static IP: `192.168.213.21`
- Install **Apache/Nginx**
    sudo apt install apache2 -y
    echo "<h1>Welcome to Corp Web Server</h1>" | sudo tee /var/www/html/index.html
- Backup Script (`/usr/local/bin/backup.sh`)
    #!/bin/bash
    DATE=$(date +%F_%H-%M)
    BACKUP_DIR="/backup/$DATE"
    mkdir -p $BACKUP_DIR
    cp -r /var/www/html $BACKUP_DIR
    mysqldump -u corpuser -p'Password123' company > $BACKUP_DIR/company.sql
    echo "Backup completed at $DATE"
- Cron Job (daily at 2 AM)
    0 2 * * * /usr/local/bin/backup.sh

## 📊 Network Diagram
graph TD
    A[Windows Server<br/>AD + DNS + DHCP + File Shares<br/>192.168.213.20]
    B[Linux Server<br/>Web + DB + Backup Scripts<br/>192.168.213.21]
    C[Windows 10 Client<br/>Employee/User<br/>192.168.213.40]
    A --- B
    A --- C
    B --- C

## 🚀 Outcomes
- Centralized **authentication & file sharing** via Windows Server.
- **Domain-joined client** (Windows 10).
- **Web + Database services** on Linux.
- Automated **daily backups** with Bash scripting.
- Extensible for advanced features:
  - Linux ↔ AD integration
  - Monitoring & logging
  - Cloud extensions

