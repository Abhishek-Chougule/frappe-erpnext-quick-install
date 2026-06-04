```bash
#!/usr/bin/env bash

# ============================================================
#  Generic Frappe / ERPNext Installer
#
#  Maintained By : Abhishek Chougule
#  GitHub        : https://github.com/Abhishek-Chougule
#
#  Supports:
#   - ERPNext v15
#   - ERPNext v16
#   - Ubuntu 22.04 / 24.04
#
# ============================================================

set -e
trap 'handle_error $LINENO' ERR

# ============================================================
# ERROR HANDLER
# ============================================================

handle_error() {

    local line=$1

    echo ""
    echo "======================================================"
    echo " INSTALLATION FAILED"
    echo "======================================================"
    echo ""
    echo "Error occurred at line: $line"
    echo ""
    echo "Check log file:"
    echo "frappe-install.log"
    echo ""

    exit 1
}

# ============================================================
# LOGGING
# ============================================================

LOG_FILE="frappe-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# ============================================================
# COLORS
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ============================================================
# BANNER
# ============================================================

banner() {

clear

echo -e "${CYAN}"
echo "███████╗██████╗  █████╗ ██████╗ ██████╗ ███████╗"
echo "██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝"
echo "█████╗  ██████╔╝███████║██████╔╝██████╔╝█████╗  "
echo "██╔══╝  ██╔══██╗██╔══██║██╔═══╝ ██╔═══╝ ██╔══╝  "
echo "██║     ██║  ██║██║  ██║██║     ██║     ███████╗"
echo "╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝     ╚══════╝"
echo ""
echo "███████╗██████╗ ██████╗ ███╗   ██╗███████╗██╗  ██╗████████╗"
echo "██╔════╝██╔══██╗██╔══██╗████╗  ██║██╔════╝╚██╗██╔╝╚══██╔══╝"
echo "█████╗  ██████╔╝██████╔╝██╔██╗ ██║█████╗   ╚███╔╝    ██║"
echo "██╔══╝  ██╔══██╗██╔═══╝ ██║╚██╗██║██╔══╝   ██╔██╗    ██║"
echo "███████╗██║  ██║██║     ██║ ╚████║███████╗██╔╝ ██╗   ██║"
echo "╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝   ╚═╝"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Generic ERPNext Installer"
echo " Maintained By : Abhishek Chougule"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${NC}"

}

# ============================================================
# UI HELPERS
# ============================================================

section() {

echo ""
echo -e "${BLUE}======================================================${NC}"
echo -e "${WHITE}$1${NC}"
echo -e "${BLUE}======================================================${NC}"
echo ""

}

success() {

echo -e "${GREEN}[OK]${NC} $1"

}

warning() {

echo -e "${YELLOW}[WARN]${NC} $1"

}

error() {

echo -e "${RED}[ERROR]${NC} $1"

}

info() {

echo -e "${CYAN}[INFO]${NC} $1"

}

# ============================================================
# VALIDATIONS
# ============================================================

check_root() {

if [[ $EUID -eq 0 ]]; then
    error "Do NOT run this script as root."
    exit 1
fi

}

check_os() {

source /etc/os-release

if [[ "$ID" != "ubuntu" ]]; then
    error "Only Ubuntu is supported."
    exit 1
fi

UBUNTU_VERSION=$(lsb_release -rs)

if [[ "$UBUNTU_VERSION" != "22.04" && "$UBUNTU_VERSION" != "24.04" ]]; then
    error "Supported Ubuntu versions: 22.04 / 24.04"
    exit 1
fi

success "Ubuntu ${UBUNTU_VERSION} detected"

}

check_existing_installation() {

section "Checking Existing Installations"

if [[ -d "$HOME/frappe-bench" ]]; then

    warning "Existing frappe-bench detected"

    read -p "Continue anyway? (yes/no): " choice

    if [[ "$choice" != "yes" ]]; then
        exit 1
    fi

fi

success "No conflicting installation found"

}

# ============================================================
# PASSWORD FUNCTION
# ============================================================

ask_password() {

local prompt=$1
local pass1
local pass2

while true; do

    read -s -p "$prompt: " pass1
    echo

    read -s -p "Confirm Password: " pass2
    echo

    if [[ "$pass1" == "$pass2" ]]; then
        PASSWORD="$pass1"
        break
    else
        error "Passwords do not match"
    fi

done

}

# ============================================================
# INSTALL FUNCTIONS
# ============================================================

install_packages() {

section "Installing System Dependencies"

sudo apt update
sudo apt upgrade -y

sudo apt install -y \
git \
curl \
wget \
nano \
vim \
software-properties-common \
build-essential \
nginx \
supervisor \
redis-server \
xvfb \
libfontconfig \
wkhtmltopdf \
mariadb-server \
mariadb-client \
python3-dev \
python3-pip \
python3-setuptools \
python3-venv \
libmysqlclient-dev \
pkg-config \
cron \
certbot \
python3-certbot-nginx

success "System packages installed"

}

install_python() {

section "Installing Python ${PYTHON_VERSION}"

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update

sudo apt install -y \
python${PYTHON_VERSION} \
python${PYTHON_VERSION}-dev \
python${PYTHON_VERSION}-venv

success "Python ${PYTHON_VERSION} installed"

}

install_node() {

section "Installing NodeJS ${NODE_VERSION}"

curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -

sudo apt install -y nodejs

sudo npm install -g yarn

success "NodeJS ${NODE_VERSION} installed"
success "Yarn installed"

}

configure_mariadb() {

section "Configuring MariaDB"

sudo tee /etc/mysql/mariadb.conf.d/99-frappe.cnf > /dev/null <<EOF
[mysqld]

innodb-file-format=barracuda
innodb-file-per-table=1
innodb-large-prefix=1

character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4
EOF

sudo systemctl restart mariadb

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

success "MariaDB configured"

}

install_bench() {

section "Installing Bench"

pip3 install --user frappe-bench

if ! grep -q '.local/bin' ~/.bashrc; then
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
fi

export PATH=$HOME/.local/bin:$PATH

success "Bench installed"

}

init_bench() {

section "Initializing Bench"

bench init ${BENCH_NAME} \
--version ${FRAPPE_BRANCH} \
--python python${PYTHON_VERSION}

cd ${BENCH_NAME}

success "Bench initialized"

}

install_erpnext() {

section "Installing ERPNext"

bench get-app erpnext \
--branch ${ERP_BRANCH} \
https://github.com/frappe/erpnext

success "ERPNext app downloaded"

}

create_site() {

section "Creating Site"

bench new-site ${SITE_NAME} \
--mariadb-root-password ${DB_ROOT_PASSWORD} \
--admin-password ${ADMIN_PASSWORD}

bench --site ${SITE_NAME} install-app erpnext

success "Site created successfully"

}

setup_production() {

section "Setting Up Production"

sudo env PATH=$PATH bench setup production $USER

bench --site ${SITE_NAME} scheduler enable

sudo supervisorctl restart all || true
sudo systemctl restart nginx

success "Production setup completed"

}

setup_ssl() {

section "SSL Configuration"

read -p "Install SSL using Let's Encrypt? (yes/no): " ssl_choice

if [[ "$ssl_choice" == "yes" ]]; then

    read -p "Enter Email Address: " EMAIL

    sudo certbot --nginx \
    --non-interactive \
    --agree-tos \
    --email ${EMAIL} \
    -d ${SITE_NAME}

    success "SSL Installed Successfully"

else

    warning "SSL Skipped"

fi

}

validate_installation() {

section "Validating Installation"

bench doctor || true

bench version

sudo supervisorctl status || true

success "Validation completed"

}

# ============================================================
# MAIN
# ============================================================

banner

check_root
check_os
check_existing_installation

section "ERPNext Version Selection"

echo "1) ERPNext v15"
echo "2) ERPNext v16"
echo ""

read -p "Enter Choice [1-2]: " VERSION

case $VERSION in

1)

FRAPPE_BRANCH="version-15"
ERP_BRANCH="version-15"
PYTHON_VERSION="3.10"
NODE_VERSION="18"

;;

2)

FRAPPE_BRANCH="version-16"
ERP_BRANCH="version-16"
PYTHON_VERSION="3.11"
NODE_VERSION="20"

;;

*)

error "Invalid Choice"
exit 1

;;

esac

section "Server Configuration"

read -p "Bench Name [frappe-bench]: " BENCH_NAME
BENCH_NAME=${BENCH_NAME:-frappe-bench}

read -p "Site Name / Domain: " SITE_NAME

echo ""
info "Set MariaDB Root Password"
ask_password "MariaDB Password"
DB_ROOT_PASSWORD="$PASSWORD"

echo ""
info "Set Administrator Password"
ask_password "Administrator Password"
ADMIN_PASSWORD="$PASSWORD"

echo ""

section "Installation Summary"

echo "Bench Name      : ${BENCH_NAME}"
echo "Site Name       : ${SITE_NAME}"
echo "ERPNext Version : ${FRAPPE_BRANCH}"
echo "Python Version  : ${PYTHON_VERSION}"
echo "Node Version    : ${NODE_VERSION}"

echo ""

read -p "Start Installation? (yes/no): " CONTINUE

if [[ "$CONTINUE" != "yes" ]]; then
    warning "Installation cancelled"
    exit 0
fi

# ============================================================
# INSTALL START
# ============================================================

install_packages
install_python
install_node
configure_mariadb
install_bench
init_bench
install_erpnext
create_site
setup_production
setup_ssl
validate_installation

SERVER_IP=$(hostname -I | awk '{print $1}')

# ============================================================
# COMPLETE
# ============================================================

echo ""
echo -e "${GREEN}"
echo "======================================================"
echo " ERPNEXT INSTALLATION COMPLETED SUCCESSFULLY"
echo "======================================================"
echo ""
echo "Site URL:"
echo "http://${SITE_NAME}"
echo "http://${SERVER_IP}"
echo ""
echo "Bench Folder:"
echo "${BENCH_NAME}"
echo ""
echo "Useful Commands:"
echo ""
echo "cd ${BENCH_NAME}"
echo "bench start"
echo "bench restart"
echo "bench update"
echo "bench doctor"
echo ""
echo "Installation Log:"
echo "${LOG_FILE}"
echo ""
echo "======================================================"
echo -e "${NC}"
```
