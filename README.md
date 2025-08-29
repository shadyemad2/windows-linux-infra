# 🖥️ Hybrid Infrastructure (Windows + Linux) With Monitoring Using Prometheus & Grafana

<img width="616" height="538" alt="Screenshot (1003)" src="https://github.com/user-attachments/assets/09dcfb88-a2a1-4fc6-92d8-90f1bd2ecf50" />

This project is a **practical lab environment** built on **VMware Workstation/Player** to simulate a small company IT infrastructure.  
It integrates:

- **Windows Server** (Active Directory, DNS, DHCP, File Sharing)  
- **Linux Server** (Web Server, Database, Backup, Bash Scripts, Monitoring)  
- **Windows 10 Client** (Domain User Workstation)

---

## ⚙️ Step 1 – Environment Setup

- **Platform**: VMware Workstation / VMware Player  
- **ISOs Required**:
  - Windows Server 2019/2022  
  - Ubuntu Server (or CentOS/RHEL)  
  - Windows 10 Pro  
- **Network**: Host-Only/Internal (all VMs in the same LAN)

---

## ⚙️ Step 2 – Windows Server (192.168.213.20)

### Install & Configure:
- **Active Directory Domain Services (AD DS)**  
- **DNS Server**  
- **DHCP Server**  
- **Domain**: `shady.local`
  
### Organizational Units (OUs):
- `hr`  
- `it`  
- `sales`  

### Users & Groups:
- Create per-department users/groups.  

### Shared Folders:
- `\\192.168.213.20\hr-folder`  
- `\\192.168.213.20\it-folder`  
- `\\192.168.213.20\sales-folder`

<img width="1053" height="783" alt="OUs" src="https://github.com/user-attachments/assets/deaaa84a-ea39-422a-8024-aa693e8b4d3f" />
<img width="1085" height="500" alt="DHCP" src="https://github.com/user-attachments/assets/b13dcd2e-3ddb-4f49-8c1c-d69a854155f3" />
<img width="1440" height="736" alt="shared-folders" src="https://github.com/user-attachments/assets/40c82153-f6d8-4325-b775-26100db35475" />

---

## ⚙️ Step 3 – Windows 10 Client (192.168.213.40)

- Configure **Static/DHCP IP**  
- Join **Domain shady.local**  
- Login with **AD user account**  
- Access **shared folders** from Windows Server

<img width="1869" height="864" alt="app" src="https://github.com/user-attachments/assets/5b84f475-ada4-4c60-a42c-44e347172743" />

---

## ⚙️ Step 4 – Linux Server (192.168.213.21)

### Install Web Server:
```bash
sudo apt update && sudo apt install apache2 -y
echo "Welcome to Corp Web Server" | sudo tee /var/www/html/index.html
```

### Backup Script `/usr/local/bin/backup.sh`:
```bash
#!/bin/bash
DATE=$(date +%F_%H-%M)
BACKUP_DIR="/backup/$DATE"
mkdir -p $BACKUP_DIR
cp -r /var/www/html $BACKUP_DIR
mysqldump -u corpuser -p'Password123' company > $BACKUP_DIR/company.sql
echo "Backup completed at $DATE"
```

<img width="845" height="437" alt="script" src="https://github.com/user-attachments/assets/84608ffd-3251-48d6-8aa9-3cc70589b5cb" />

### Cron Job (daily at 2 AM):
```bash
0 2 * * * /usr/local/bin/backup.sh
```

---

## 📊 Network Diagram

```mermaid
graph TD
  A[Windows Server\nAD + DNS + DHCP + File Shares\n192.168.213.20]
  B[Linux Server\nWeb + DB + Backup Scripts\n192.168.213.21]
  C[Windows 10 Client\nEmployee/User\n192.168.213.40]
  A --- B
  A --- C
  B --- C
```

---

## 📈 Monitoring with Prometheus & Grafana

### Prometheus + Node Exporter (Linux):
```bash
sudo apt install prometheus -y
wget https://github.com/prometheus/node_exporter/releases/download/v*/node_exporter-*.linux-amd64.tar.gz
tar xvf node_exporter-*.tar.gz
./node_exporter &
```

### Prometheus Config (`prometheus.yml`):
```yaml
scrape_configs:
  - job_name: 'linux_server'
    static_configs:
      - targets: ['192.168.213.21:9100']

  - job_name: 'windows_server'
    static_configs:
      - targets: ['192.168.213.20:9182']
```
<img width="1515" height="813" alt="prometheus" src="https://github.com/user-attachments/assets/bc65e22f-44bf-470f-af9a-eb2e04358fb2" />
<img width="1841" height="790" alt="metrics" src="https://github.com/user-attachments/assets/f3f4d95b-c0f4-4425-87ce-d943129c84b3" />


### Windows Server Exporter:
- Install **WMI Exporter (windows_exporter)**.  
- Default port: **9182**.  
- Provides: CPU, Memory, Disk, Network metrics.

<img width="1191" height="782" alt="windows-exporter" src="https://github.com/user-attachments/assets/5056e2db-c3fb-4528-a399-7bc536f253ff" />


### Grafana Setup:
```bash
sudo apt install grafana -y
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

- Access: `http://192.168.213.21:3000`  
- Add **Prometheus** as a data source.  
- Import pre-built dashboards for Linux & Windows.  

---
<img width="1595" height="740" alt="grafana-linux" src="https://github.com/user-attachments/assets/fedd91d3-bb19-4000-9620-5d29e5caa937" />
<img width="1613" height="740" alt="grafana-windows" src="https://github.com/user-attachments/assets/c7d9a6d3-d31e-47d6-b514-1357dfad119a" />


## 🚀 Outcomes

✅ Centralized authentication & file sharing via Windows Server.  
✅ Domain-joined Windows 10 client.  
✅ Web + Database services on Linux.  
✅ Automated daily backups with Bash scripting.  
✅ Real-time monitoring with Prometheus & Grafana.  

---

Made by [**Shady Emad**](https://github.com/shadyemad2)


