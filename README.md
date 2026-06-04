# Generic Frappe / ERPNext Installer

Production-ready automated installer for Frappe Framework and ERPNext on Ubuntu 22.04 / 24.04 with support for ERPNext v15 and v16.

Repository:
[frappe-erpnext-quick-install](https://github.com/Abhishek-Chougule/frappe-erpnext-quick-install?utm_source=chatgpt.com)

Maintained By:
Abhishek Chougule

---

# Features

* Fully Automated ERPNext Installation
* Supports ERPNext v15
* Supports ERPNext v16
* Ubuntu 22.04 Support
* Ubuntu 24.04 Support
* Interactive Terminal UI
* Automatic Python Version Selection
* Automatic NodeJS Version Selection
* Automatic MariaDB Configuration
* Automatic Redis Installation
* Automatic Bench Installation
* Automatic Site Creation
* Automatic ERPNext Installation
* Production Setup Included
* NGINX Configuration
* Supervisor Configuration
* SSL Setup with Let's Encrypt
* Installation Logging
* Existing Installation Detection
* UTF8MB4 MariaDB Optimization
* Scheduler Auto Enable
* Production Ready

---

# Supported Versions

| ERPNext Version | Python Version | NodeJS Version |
| --------------- | -------------- | -------------- |
| v15             | Python 3.10    | NodeJS 18      |
| v16             | Python 3.11    | NodeJS 20      |

---

# Supported Operating Systems

* Ubuntu 22.04 LTS
* Ubuntu 24.04 LTS

---

# Minimum Server Requirements

| Resource | Minimum              |
| -------- | -------------------- |
| CPU      | 2 Core               |
| RAM      | 4 GB                 |
| Storage  | 40 GB SSD            |
| OS       | Ubuntu 22.04 / 24.04 |

---

# Recommended Production Requirements

| Resource | Recommended |
| -------- | ----------- |
| CPU      | 4 Core      |
| RAM      | 8 GB+       |
| Storage  | 80 GB SSD   |
| Swap     | 4 GB        |

---

# Installation

## Step 1 Clone Repository

```bash id="rjjlwm"
git clone https://github.com/Abhishek-Chougule/frappe-erpnext-quick-install.git
```

---

## Step 2 Enter Repository

```bash id="f6svdf"
cd frappe-erpnext-quick-install
```

---

## Step 3 Make Script Executable

```bash id="g7whv8"
chmod +x install.sh
```

---

## Step 4 Run Installer

```bash id="kz2i5j"
./install.sh
```

---

# Installation Flow

The installer automatically performs:

* System Update
* Dependency Installation
* Python Installation
* NodeJS Installation
* Yarn Installation
* MariaDB Installation
* MariaDB Configuration
* Redis Installation
* Bench Installation
* Bench Initialization
* ERPNext App Installation
* Site Creation
* Production Setup
* NGINX Setup
* Supervisor Setup
* Scheduler Enable
* SSL Installation (Optional)

---

# Interactive Installation

The installer will ask for:

* ERPNext Version
* Bench Name
* Site Name / Domain
* MariaDB Root Password
* Administrator Password
* SSL Installation Preference

---

# Example Installation

```text id="a7x93k"
ERPNext Version : version-16
Bench Name      : frappe-bench
Site Name       : erp.example.com
Python Version  : 3.11
Node Version    : 20
```

---

# Production Setup

The installer automatically configures:

* NGINX
* Supervisor
* Redis
* Bench Production Mode
* Scheduler
* SocketIO
* System Services

---

# SSL Setup

The installer supports automatic SSL installation using Let's Encrypt.

Requirements:

* Domain must point to your server IP
* Port 80 and 443 should be open
* Valid DNS configuration

---

# Useful Commands

## Go To Bench Directory

```bash id="jlwmu8"
cd frappe-bench
```

---

## Start Development Server

```bash id="0s4xwe"
bench start
```

---

## Restart Production Services

```bash id="10e3gj"
bench restart
```

---

## Update ERPNext

```bash id="9xjlwm"
bench update
```

---

## Check Bench Health

```bash id="jlwmj2"
bench doctor
```

---

## Check Installed Versions

```bash id="jlwmr8"
bench version
```

---

## Restart Supervisor

```bash id="jlwmx1"
sudo supervisorctl restart all
```

---

## Check Supervisor Status

```bash id="jlwmk5"
sudo supervisorctl status
```

---

## Restart NGINX

```bash id="jlwmn7"
sudo systemctl restart nginx
```

---

## Check NGINX Status

```bash id="jlwmv9"
sudo systemctl status nginx
```

---

# Default Ports

| Service        | Port  |
| -------------- | ----- |
| ERPNext        | 8000  |
| HTTP           | 80    |
| HTTPS          | 443   |
| Redis Queue    | 11000 |
| Redis SocketIO | 12000 |
| Redis Cache    | 13000 |

---

# Installation Log

Installation logs are automatically saved in:

```bash id="jlwmq3"
frappe-install.log
```

---

# Troubleshooting

## Bench Command Not Found

Run:

```bash id="jlwmf4"
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## Fix Supervisor Issues

```bash id="jlwmh6"
sudo supervisorctl reload
sudo supervisorctl restart all
```

---

## Rebuild Assets

```bash id="jlwmz0"
bench build
```

---

## Restart Entire Stack

```bash id="jlwmc2"
bench restart
```

---

# Security Recommendations

* Use strong passwords
* Enable firewall
* Keep Ubuntu updated
* Use SSL in production
* Restrict SSH access
* Configure regular backups
* Disable root login
* Enable fail2ban

---

# Tested Environment

| OS           | ERPNext | Status |
| ------------ | ------- | ------ |
| Ubuntu 22.04 | v15     | Tested |
| Ubuntu 24.04 | v16     | Tested |

---

# Repository Structure

```text id="jlwmt1"
.
├── install.sh
├── README.md
└── frappe-install.log
```

---

# Maintainer

Abhishek Chougule

GitHub:
https://github.com/Abhishek-Chougule

Repository:
https://github.com/Abhishek-Chougule/frappe-erpnext-quick-install

---

# License

MIT License

---

# Disclaimer

This installer is provided as-is without warranty. Always test in a staging environment before using in production environments.

---

# Official Resources

* https://frappeframework.com
* https://erpnext.com
* https://github.com/frappe/frappe
* https://github.com/frappe/erpnext
