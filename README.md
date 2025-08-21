# 🖥️ Hybrid Infrastructure Lab (Windows + Linux)
This project is a **practical lab environment** built on VMware to simulate a small company IT infrastructure. It integrates **Windows Server (AD, DNS, DHCP, File Share)**, **Linux Server (Web, DB, Backup, Bash Scripts)**, and a **Windows 10 Client**.

<img width="921" height="634" alt="diagram" src="https://github.com/user-attachments/assets/985fefc2-da00-4bcd-8bb8-2cbd2962f376" />

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
  
<img width="1053" height="783" alt="OUs" src="https://github.com/user-attachments/assets/d5088a7a-3ac5-4733-a780-5bbee832c212" />
<img width="1085" height="500" alt="DHCP" src="https://github.com/user-attachments/assets/5a24a8ec-02ea-414b-8ce7-b4b3694326e3" />
<img width="1440" height="736" alt="shared-folders" src="https://github.com/user-attachments/assets/71da8f9c-70a4-4ea5-8b18-f21460b279a8" />

  

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
  
<img width="845" height="437" alt="script" src="https://github.com/user-attachments/assets/8491f5bb-83ed-4cc7-bea6-e050938ab646" />
  

## 📊 Network Diagram
graph TD
    A[Windows Server<br/>AD + DNS + DHCP + File Shares<br/>192.168.213.20]
    B[Linux Server<br/>Web + DB + Backup Scripts<br/>192.168.213.21]
    C[Windows 10 Client<br/>Employee/User<br/>192.168.213.40]
    A --- B
    A --- C
    B --- C

## 🚀 Outcomes

<img width="1869" height="864" alt="app" src="https://github.com/user-attachments/assets/7f6fdcab-222e-431b-ad3c-aef72a4e2700" />

- Centralized **authentication & file sharing** via Windows Server.
- **Domain-joined client** (Windows 10).
- **Web + Database services** on Linux.
- Automated **daily backups** with Bash scripting.
- Extensible for advanced features:
  - Linux ↔ AD integration
  - Monitoring & logging
  - Cloud extensions

