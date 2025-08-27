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

 ## Prometeus and Grafana
 
- **Install Prometheus + Node Exporter:**
  sudo apt install prometheus -y
wget https://github.com/prometheus/node_exporter/releases/download/v*/node_exporter-*.linux-amd64.tar.gz
tar xvf node_exporter-*.tar.gz
./node_exporter &

- **Configure Prometheus (prometheus.yml):**
  scrape_configs:
  - job_name: 'linux_server'
    static_configs:
      - targets: ['192.168.213.21:9100']
  - job_name: 'windows_server'
    static_configs:
      - targets: ['192.168.213.20:9182']

 <img width="1515" height="813" alt="prometheus" src="https://github.com/user-attachments/assets/a2c50092-2138-4cd9-8cbd-a7175ea8ab3b" />
 <img width="1841" height="790" alt="metrics" src="https://github.com/user-attachments/assets/750b9df8-595f-4f92-83f5-4418c91bccaf" />
 
 ## 🔹 Windows Server Exporter
- Install WMI Exporter (windows_exporter).
- Default port: 9182.
- Provides CPU, Memory, Disk, Network metrics.
  
<img width="1191" height="782" alt="windows-exporter" src="https://github.com/user-attachments/assets/00eca679-cd1b-4879-a6f4-a0d57b380474" />
  
 ## 🔹 Grafana Setup
sudo apt install grafana -y
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
- Access: http://192.168.213.21:3000
- Add Prometheus as a Data Source.
- Import pre-built dashboards for Linux & Windows.
  
<img width="1595" height="740" alt="grafana-linux" src="https://github.com/user-attachments/assets/643a1b15-2329-4862-87f3-1b2ae5448c44" />
<img width="1613" height="740" alt="grafana-windows" src="https://github.com/user-attachments/assets/930bbc48-ab77-4d46-a122-8dd73402c014" />
 

 ## 🚀 Outcomes

✅ Centralized authentication & file sharing via Windows Server.
✅ Domain-joined Windows 10 client.
✅ Web + Database services on Linux.
✅ Automated daily backups with Bash scripting.
✅ Real-time Monitoring with Prometheus & Grafana.
