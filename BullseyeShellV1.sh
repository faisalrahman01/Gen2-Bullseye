#!/bin/bash

# ===============================================
# GEN2 - Shell Menu Interface
# ===============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
WEB_PORTAL_PORT=5000
SERVICE_NAME="gen2-web-portal.service"

# Function to display header
show_header() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                   GEN2 Deployment Manager                    ║"
    echo "║                   Complete BULLSEYE Edition                  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to display system info
show_system_info() {
    echo -e "${CYAN}📊 System Information:${NC}"
    echo "    Hostname: $(hostname)"
    echo "    Architecture: $(dpkg --print-architecture 2>/dev/null || echo "unknown")"
    echo "    OS: $(lsb_release -d | cut -f2) ($(lsb_release -sc))"
    echo "    IP Address: $(hostname -I | awk '{print $1}')"
    echo "    Uptime: $(uptime -p)"
    echo ""
}

# Function to check service status
check_service_status() {
    local service=$1
    if systemctl is-active --quiet "$service"; then
        echo -e "  Status: ${GREEN}Running${NC}"
    else
        echo -e "  Status: ${RED}Stopped${NC}"
    fi
}

# Function to check package installation
check_package() {
    local package=$1
    if command -v "$package" &> /dev/null; then
        echo -e "  Status: ${GREEN}Installed${NC}"
    else
        echo -e "  Status: ${RED}Not Installed${NC}"
    fi
}

# Function to check Docker container
check_docker_container() {
    local container=$1
    if sudo docker ps --format "table {{.Names}}" | grep -q "$container"; then
        echo -e "  Status: ${GREEN}Running${NC}"
    elif sudo docker ps -a --format "table {{.Names}}" | grep -q "$container"; then
        echo -e "  Status: ${YELLOW}Stopped${NC}"
    else
        echo -e "  Status: ${RED}Not Found${NC}"
    fi
}

# Main menu
main_menu() {
    while true; do
        show_header
        show_system_info
        
        echo -e "${CYAN}🏠 Main Menu - Select an option:${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 📊 System Status Dashboard"
        echo -e "  ${GREEN}2${NC}) ⚙️  System Configuration"
        echo -e "  ${GREEN}3${NC}) 📦 Package Management"
        echo -e "  ${GREEN}4${NC}) 🚀 Service Deployment"
        echo -e "  ${GREEN}5${NC}) 🌐 Web Portal Access"
        echo -e "  ${GREEN}6${NC}) 🔧 Service Control"
        echo -e "  ${GREEN}7${NC}) 📋 View Logs"
        echo -e "  ${GREEN}8${NC}) 🔄 Reboot System"
        echo -e "  ${GREEN}9${NC}) ❌ Exit to Shell"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-9]: ${NC}\c"
        read choice

        case $choice in
            1) system_status_menu ;;
            2) system_config_menu ;;
            3) package_menu ;;
            4) deployment_menu ;;
            5) web_portal_menu ;;
            6) service_control_menu ;;
            7) logs_menu ;;
            8) reboot_menu ;;
            9) echo -e "\n${GREEN}Returning to shell...${NC}"; exit 0 ;;
            *) echo -e "\n${RED}Invalid option! Please try again.${NC}"; sleep 2 ;;
        esac
    done
}

# System Status Menu
system_status_menu() {
    while true; do
        show_header
        echo -e "${CYAN}📊 System Status Dashboard${NC}"
        echo ""
        
        # System Information
        echo -e "${BLUE}💻 System Info:${NC}"
        echo "    Hostname: $(hostname)"
        echo "    Architecture: $(dpkg --print-architecture)"
        echo "    OS: $(lsb_release -d | cut -f2)"
        echo "    Kernel: $(uname -r)"
        echo "    Uptime: $(uptime -p)"
        echo ""
        
        # Network Information
        echo -e "${BLUE}🌐 Network:${NC}"
        echo "    IP Address: $(hostname -I | awk '{print $1}')"
        echo "    WiFi: $(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes:' | cut -d: -f2 || echo 'Not connected')"
        echo ""
        
        # Service Status
        echo -e "${BLUE}🔧 Services:${NC}"
        echo -n "    Web Portal: "; check_service_status "$SERVICE_NAME"
        echo -n "    Docker: "; check_service_status "docker"
        echo -n "    Cockpit: "; check_service_status "cockpit.socket"
        echo ""
        
        # Package Status
        echo -e "${BLUE}📦 Packages:${NC}"
        echo -n "    Tailscale: "; check_package "tailscale"
        echo -n "    Docker CLI: "; check_package "docker"
        echo -n "    Cockpit: "; check_package "cockpit-bridge"
        echo ""
        
        # Docker Containers
        if command -v docker &> /dev/null; then
            echo -e "${BLUE}🐳 Docker Containers:${NC}"
            echo -n "    Uptime Kuma: "; check_docker_container "uptime-kuma"
            echo ""
        fi
        
        # System Resources
        echo -e "${BLUE}📈 Resources:${NC}"
        echo "    CPU Load: $(uptime | awk -F'load average:' '{print $2}')"
        echo "    Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
        echo "    Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
        echo ""
        
        echo -e "${YELLOW}Press [Enter] to return to main menu...${NC}\c"
        read
        break
    done
}

# System Configuration Menu
system_config_menu() {
    while true; do
        show_header
        echo -e "${CYAN}⚙️  System Configuration${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 🏷️  Change Hostname"
        echo -e "  ${GREEN}2${NC}) 📶 Configure WiFi"
        echo -e "  ${GREEN}3${NC}) 🌐 Network Configuration"
        echo -e "  ${GREEN}4${NC}) ⏰ Configure Timezone"
        echo -e "  ${GREEN}5${NC}) 🔙 Back to Main Menu"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-5]: ${NC}\c"
        read choice

        case $choice in
            1) change_hostname ;;
            2) configure_wifi ;;
            3) network_config ;;
            4) configure_timezone ;;
            5) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Change Hostname
change_hostname() {
    show_header
    echo -e "${CYAN}🏷️  Change Hostname${NC}"
    echo ""
    echo -e "Current hostname: ${GREEN}$(hostname)${NC}"
    echo ""
    echo -e "Enter new hostname: \c"
    read new_hostname
    
    if [[ -n "$new_hostname" ]]; then
        # Validate hostname
        if [[ "$new_hostname" =~ ^[a-zA-Z0-9-]+$ ]] && [[ ${#new_hostname} -le 63 ]]; then
            echo ""
            echo -e "${YELLOW}Setting hostname to: $new_hostname${NC}"
            sudo hostnamectl set-hostname "$new_hostname"
            sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$new_hostname/g" /etc/hosts
            echo -e "${GREEN}✅ Hostname changed successfully!${NC}"
            echo -e "${YELLOW}Note: Changes will take effect after reboot.${NC}"
        else
            echo -e "${RED}❌ Invalid hostname! Use only letters, numbers, and hyphens (max 63 chars).${NC}"
        fi
    else
        echo -e "${RED}❌ No hostname entered!${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Configure WiFi
configure_wifi() {
    show_header
    echo -e "${CYAN}📶 Configure WiFi${NC}"
    echo ""
    
    # Check if NetworkManager is available
    if ! command -v nmcli &> /dev/null; then
        echo -e "${YELLOW}Installing NetworkManager...${NC}"
        sudo apt update && sudo apt install -y network-manager
    fi
    
    echo -e "Available WiFi networks:"
    echo -e "${YELLOW}Scanning...${NC}"
    sudo nmcli dev wifi list
    echo ""
    
    echo -e "Enter SSID: \c"
    read wifi_ssid
    echo -e "Enter Password: \c"
    read -s wifi_password
    echo ""
    
    if [[ -n "$wifi_ssid" && -n "$wifi_password" ]]; then
        echo ""
        echo -e "${YELLOW}Connecting to $wifi_ssid...${NC}"
        sudo nmcli dev wifi connect "$wifi_ssid" password "$wifi_password"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Successfully connected to $wifi_ssid${NC}"
        else
            echo -e "${RED}❌ Failed to connect to $wifi_ssid${NC}"
        fi
    else
        echo -e "${RED}❌ SSID and password are required!${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Network Configuration
network_config() {
    show_header
    echo -e "${CYAN}🌐 Network Configuration${NC}"
    echo ""
    echo -e "Current IP addresses:"
    ip addr show | grep -E "inet (192|10|172)" | awk '{print "  " $2 " on " $NF}'
    echo ""
    echo -e "${YELLOW}For advanced network configuration, use:${NC}"
    echo "  sudo nmtui (text-based network config)"
    echo "  sudo raspi-config (Raspberry Pi config)"
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Configure Timezone
configure_timezone() {
    show_header
    echo -e "${CYAN}⏰ Configure Timezone${NC}"
    echo ""
    echo -e "Current timezone: ${GREEN}$(timedatectl show --property=Timezone --value)${NC}"
    echo ""
    echo -e "Select timezone configuration method:"
    echo -e "  ${GREEN}1${NC}) Use interactive menu"
    echo -e "  ${GREEN}2${NC}) Enter timezone manually (e.g., America/New_York)"
    echo -e "  ${GREEN}3${NC}) Cancel"
    echo ""
    echo -e "Enter choice [1-3]: \c"
    read choice
    
    case $choice in
        1)
            sudo dpkg-reconfigure tzdata
            ;;
        2)
            echo -e "Enter timezone: \c"
            read tz
            if sudo timedatectl set-timezone "$tz" 2>/dev/null; then
                echo -e "${GREEN}✅ Timezone set to $tz${NC}"
            else
                echo -e "${RED}❌ Invalid timezone!${NC}"
            fi
            ;;
        3)
            return
            ;;
        *)
            echo -e "${RED}❌ Invalid choice!${NC}"
            ;;
    esac
    
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Package Management Menu
package_menu() {
    while true; do
        show_header
        echo -e "${CYAN}📦 Package Management${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 🔍 Check Package Status"
        echo -e "  ${GREEN}2${NC}) 📥 Install Individual Packages"
        echo -e "  ${GREEN}3${NC}) 🗑️  Remove Packages"
        echo -e "  ${GREEN}4${NC}) 🔄 Update System Packages"
        echo -e "  ${GREEN}5${NC}) 🛠️  Fix Uptime Kuma"
        echo -e "  ${GREEN}6${NC}) 🔙 Back to Main Menu"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-6]: ${NC}\c"
        read choice

        case $choice in
            1) check_package_status ;;
            2) install_packages_menu ;;
            3) remove_packages_menu ;;
            4) update_system ;;
            5) fix_uptime_kuma ;;
            6) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Check Package Status
check_package_status() {
    show_header
    echo -e "${CYAN}🔍 Package Status${NC}"
    echo ""
    
    declare -A packages=(
        ["Tailscale"]="tailscale"
        ["Docker"]="docker"
        ["Cockpit"]="cockpit-bridge"
        ["NetworkManager"]="nmcli"
    )
    
    for name in "${!packages[@]}"; do
        cmd=${packages[$name]}
        echo -n "    $name: "
        if command -v "$cmd" &> /dev/null || dpkg -l | grep -q "$cmd" || systemctl list-unit-files | grep -q "$cmd"; then
            echo -e "${GREEN}Installed${NC}"
        else
            echo -e "${RED}Not Installed${NC}"
        fi
    done
    
    # Check Docker containers
    if command -v docker &> /dev/null; then
        echo ""
        echo -e "${BLUE}🐳 Docker Containers:${NC}"
        sudo docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | head -10
    fi
    
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Install Packages Menu
install_packages_menu() {
    while true; do
        show_header
        echo -e "${CYAN}📥 Install Packages${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 🔗 Install Tailscale VPN"
        echo -e "  ${GREEN}2${NC}) 🐳 Install Docker"
        echo -e "  ${GREEN}3${NC}) ⚙️  Install Cockpit Web Admin"
        echo -e "  ${GREEN}4${NC}) 📊 Install Uptime Kuma"
        echo -e "  ${GREEN}5${NC}) 🔙 Back to Package Menu"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-5]: ${NC}\c"
        read choice

        case $choice in
            1) install_tailscale ;;
            2) install_docker ;;
            3) install_cockpit ;;
            4) install_uptime_kuma ;;
            5) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Install Tailscale
install_tailscale() {
    show_header
    echo -e "${CYAN}🔗 Installing Tailscale VPN${NC}"
    echo ""
    
    if command -v tailscale &> /dev/null; then
        echo -e "${YELLOW}Tailscale is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing Tailscale...${NC}"
        curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
        curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
        sudo apt-get update
        sudo apt-get install -y tailscale
        sudo systemctl enable --now tailscaled
        
        echo -e "${GREEN}✅ Tailscale installed successfully!${NC}"
        echo ""
        echo -e "${YELLOW}To connect to your Tailscale network, run:${NC}"
        echo "  sudo tailscale up --auth-key YOUR_AUTH_KEY"
        echo ""
        echo -e "${BLUE}Get your auth key from: https://login.tailscale.com/admin/settings/keys${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Install Docker
install_docker() {
    show_header
    echo -e "${CYAN}🐳 Installing Docker${NC}"
    echo ""
    
    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}Docker is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing Docker...${NC}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        sudo systemctl enable docker
        sudo systemctl start docker
        rm get-docker.sh
        
        echo -e "${GREEN}✅ Docker installed successfully!${NC}"
        echo ""
        echo -e "${YELLOW}Note: You may need to logout and login again for group changes to take effect.${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Install Cockpit
install_cockpit() {
    show_header
    echo -e "${CYAN}⚙️  Installing Cockpit Web Admin${NC}"
    echo ""
    
    if systemctl is-active --quiet cockpit.socket; then
        echo -e "${YELLOW}Cockpit is already installed and running.${NC}"
    else
        echo -e "${YELLOW}Installing Cockpit...${NC}"
        sudo apt update
        sudo apt install -y cockpit
        sudo systemctl enable --now cockpit.socket
        
        echo -e "${GREEN}✅ Cockpit installed successfully!${NC}"
        echo ""
        echo -e "${YELLOW}Access Cockpit at: https://$(hostname -I | awk '{print $1}'):9090${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Install Uptime Kuma
install_uptime_kuma() {
    show_header
    echo -e "${CYAN}📊 Installing Uptime Kuma${NC}"
    echo ""
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker is required but not installed. Please install Docker first.${NC}"
        echo ""
        echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
        read
        return
    fi
    
    if sudo docker ps -a --format "table {{.Names}}" | grep -q uptime-kuma; then
        echo -e "${YELLOW}Uptime Kuma container already exists.${NC}"
        echo ""
        echo -e "Would you like to recreate it? (y/N): \c"
        read recreate
        if [[ "$recreate" =~ ^[Yy]$ ]]; then
            sudo docker stop uptime-kuma 2>/dev/null
            sudo docker rm uptime-kuma 2>/dev/null
        else
            sudo docker start uptime-kuma 2>/dev/null
            echo -e "${GREEN}✅ Uptime Kuma started!${NC}"
            echo ""
            echo -e "${YELLOW}Access at: http://$(hostname -I | awk '{print $1}'):3001${NC}"
            echo ""
            echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
            read
            return
        fi
    fi
    
    echo -e "${YELLOW}Deploying Uptime Kuma...${NC}"
    sudo docker run -d --restart=always -p 3001:3001 -v uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:latest
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Uptime Kuma deployed successfully!${NC}"
        echo ""
        echo -e "${YELLOW}Access at: http://$(hostname -I | awk '{print $1}'):3001${NC}"
    else
        echo -e "${RED}❌ Failed to deploy Uptime Kuma${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Remove Packages Menu
remove_packages_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🗑️  Remove Packages${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 🔗 Remove Tailscale"
        echo -e "  ${GREEN}2${NC}) 🐳 Remove Docker"
        echo -e "  ${GREEN}3${NC}) ⚙️  Remove Cockpit"
        echo -e "  ${GREEN}4${NC}) 📊 Remove Uptime Kuma"
        echo -e "  ${GREEN}5${NC}) 🔙 Back to Package Menu"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-5]: ${NC}\c"
        read choice

        case $choice in
            1) remove_tailscale ;;
            2) remove_docker ;;
            3) remove_cockpit ;;
            4) remove_uptime_kuma ;;
            5) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Remove functions (similar to web portal)
remove_tailscale() {
    echo -e "${YELLOW}Removing Tailscale...${NC}"
    sudo tailscale down 2>/dev/null
    sudo apt-get remove --purge -y tailscale
    sudo rm -f /etc/apt/sources.list.d/tailscale.list
    sudo rm -f /usr/share/keyrings/tailscale-archive-keyring.gpg
    echo -e "${GREEN}✅ Tailscale removed!${NC}"
    sleep 2
}

remove_docker() {
    echo -e "${YELLOW}Removing Docker...${NC}"
    sudo docker rm -f uptime-kuma 2>/dev/null || true
    sudo systemctl stop docker
    sudo systemctl disable docker
    sudo apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo rm -rf /var/lib/docker
    sudo rm -rf /etc/docker
    sudo groupdel docker 2>/dev/null || true
    echo -e "${GREEN}✅ Docker removed!${NC}"
    sleep 2
}

remove_cockpit() {
    echo -e "${YELLOW}Removing Cockpit...${NC}"
    sudo systemctl stop cockpit.socket
    sudo systemctl disable cockpit.socket
    sudo apt-get remove --purge -y cockpit
    echo -e "${GREEN}✅ Cockpit removed!${NC}"
    sleep 2
}

remove_uptime_kuma() {
    echo -e "${YELLOW}Removing Uptime Kuma...${NC}"
    sudo docker rm -f uptime-kuma 2>/dev/null || true
    sudo docker volume rm uptime-kuma-data 2>/dev/null || true
    echo -e "${GREEN}✅ Uptime Kuma removed!${NC}"
    sleep 2
}

# Update System
update_system() {
    show_header
    echo -e "${CYAN}🔄 Updating System Packages${NC}"
    echo ""
    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt update
    echo ""
    echo -e "${YELLOW}Upgrading packages...${NC}"
    sudo apt upgrade -y
    echo ""
    echo -e "${YELLOW}Cleaning up...${NC}"
    sudo apt autoremove -y
    sudo apt autoclean
    echo ""
    echo -e "${GREEN}✅ System update completed!${NC}"
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Fix Uptime Kuma
fix_uptime_kuma() {
    show_header
    echo -e "${CYAN}🛠️  Fixing Uptime Kuma${NC}"
    echo ""
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker is not installed!${NC}"
        echo ""
        echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
        read
        return
    fi
    
    echo -e "${YELLOW}Applying Uptime Kuma fixes...${NC}"
    echo ""
    
    # Stop and remove existing container
    sudo docker stop uptime-kuma 2>/dev/null || true
    sudo docker rm uptime-kuma 2>/dev/null || true
    
    # Try different deployment methods
    echo "1. Trying standard deployment..."
    if sudo docker run -d --name uptime-kuma -p 3001:3001 -v uptime-kuma-data:/app/data louislam/uptime-kuma:latest; then
        echo -e "${GREEN}✅ Standard deployment successful!${NC}"
    else
        echo "2. Trying alternative port..."
        sudo docker stop uptime-kuma 2>/dev/null || true
        sudo docker rm uptime-kuma 2>/dev/null || true
        if sudo docker run -d --name uptime-kuma -p 3002:3001 -v uptime-kuma-data:/app/data louislam/uptime-kuma:latest; then
            echo -e "${GREEN}✅ Alternative port deployment successful!${NC}"
            echo -e "${YELLOW}Access at: http://$(hostname -I | awk '{print $1}'):3002${NC}"
        else
            echo "3. Trying host networking..."
            sudo docker stop uptime-kuma 2>/dev/null || true
            sudo docker rm uptime-kuma 2>/dev/null || true
            if sudo docker run -d --name uptime-kuma --network host -v uptime-kuma-data:/app/data louislam/uptime-kuma:latest; then
                echo -e "${GREEN}✅ Host networking deployment successful!${NC}"
                echo -e "${YELLOW}Access at: http://$(hostname -I | awk '{print $1}'):3001${NC}"
            else
                echo -e "${RED}❌ All deployment methods failed!${NC}"
            fi
        fi
    fi
    
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Deployment Menu
deployment_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🚀 Service Deployment${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 🚀 Quick Deploy (Essential services)"
        echo -e "  ${GREEN}2${NC}) 📦 Minimal Deploy (Tailscale only)"
        echo -e "  ${GREEN}3${NC}) 🔧 Full Deploy (All services)"
        echo -e "  ${GREEN}4${NC}) 🔙 Back to Main Menu"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-4]: ${NC}\c"
        read choice

        case $choice in
            1) quick_deploy ;;
            2) minimal_deploy ;;
            3) full_deploy ;;
            4) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Deployment functions
quick_deploy() {
    show_header
    echo -e "${CYAN}🚀 Quick Deployment - Essential Services${NC}"
    echo ""
    echo -e "${YELLOW}This will install:${NC}"
    echo "  • Tailscale VPN"
    echo "  • Cockpit Web Admin"
    echo "  • Uptime Kuma (if Docker available)"
    echo ""
    echo -e "${YELLOW}Continue? (y/N): ${NC}\c"
    read confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
        install_tailscale_quick
        install_cockpit_quick
        if command -v docker &> /dev/null; then
            install_uptime_kuma_quick
        fi
        echo -e "${GREEN}✅ Quick deployment completed!${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

minimal_deploy() {
    show_header
    echo -e "${CYAN}📦 Minimal Deployment - Tailscale Only${NC}"
    echo ""
    install_tailscale_quick
    echo -e "${GREEN}✅ Minimal deployment completed!${NC}"
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

full_deploy() {
    show_header
    echo -e "${CYAN}🔧 Full Deployment - All Services${NC}"
    echo ""
    echo -e "${YELLOW}This will install:${NC}"
    echo "  • Tailscale VPN"
    echo "  • Docker"
    echo "  • Cockpit Web Admin"
    echo "  • Uptime Kuma"
    echo ""
    echo -e "${YELLOW}Continue? (y/N): ${NC}\c"
    read confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
        install_tailscale_quick
        install_docker_quick
        install_cockpit_quick
        install_uptime_kuma_quick
        echo -e "${GREEN}✅ Full deployment completed!${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Quick install functions (non-interactive)
install_tailscale_quick() {
    echo -e "${YELLOW}Installing Tailscale...${NC}"
    if ! command -v tailscale &> /dev/null; then
        curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
        curl -fsSL https://pkgs.tailscale.com/stable/debian/$(lsb_release -cs).tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
        sudo apt-get update -yq
        sudo apt-get install -yq tailscale
        sudo systemctl enable --now tailscaled
        echo -e "${GREEN}✅ Tailscale installed${NC}"
    else
        echo -e "${BLUE}ℹ️  Tailscale already installed${NC}"
    fi
}

install_docker_quick() {
    echo -e "${YELLOW}Installing Docker...${NC}"
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        sudo systemctl enable docker
        sudo systemctl start docker
        rm get-docker.sh
        echo -e "${GREEN}✅ Docker installed${NC}"
    else
        echo -e "${BLUE}ℹ️  Docker already installed${NC}"
    fi
}

install_cockpit_quick() {
    echo -e "${YELLOW}Installing Cockpit...${NC}"
    if ! systemctl is-active --quiet cockpit.socket; then
        sudo apt update -yq
        sudo apt install -yq cockpit
        sudo systemctl enable --now cockpit.socket
        echo -e "${GREEN}✅ Cockpit installed${NC}"
    else
        echo -e "${BLUE}ℹ️  Cockpit already installed${NC}"
    fi
}

install_uptime_kuma_quick() {
    echo -e "${YELLOW}Installing Uptime Kuma...${NC}"
    if command -v docker &> /dev/null; then
        sudo docker run -d --restart=always -p 3001:3001 -v uptime-kuma-data:/app/data --name uptime-kuma louislam/uptime-kuma:latest 2>/dev/null && \
        echo -e "${GREEN}✅ Uptime Kuma installed${NC}" || \
        echo -e "${BLUE}ℹ️  Uptime Kuma already running${NC}"
    else
        echo -e "${RED}❌ Docker not available for Uptime Kuma${NC}"
    fi
}

# Web Portal Menu
web_portal_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🌐 Web Portal Access${NC}"
        echo ""
        
        # Check if web portal is running
        if systemctl is-active --quiet "$SERVICE_NAME"; then
            echo -e "Web Portal Status: ${GREEN}Running ✅${NC}"
            echo ""
            echo -e "${YELLOW}Access the web portal at:${NC}"
            echo -e "  ${BLUE}http://$(hostname -I | awk '{print $1}'):$WEB_PORTAL_PORT${NC}"
            echo ""
            echo -e "Default credentials:"
            echo -e "  Username: ${GREEN}admin${NC}"
            echo -e "  Password: ${GREEN}admin${NC}"
            echo ""
            echo -e "${RED}⚠️  Change the default password after first login!${NC}"
            echo ""
        else
            echo -e "Web Portal Status: ${RED}Stopped ❌${NC}"
            echo ""
            echo -e "${YELLOW}The web portal service is not running.${NC}"
            echo ""
        fi
        
        echo -e "  ${GREEN}1${NC}) 🚀 Start Web Portal"
        echo -e "  ${GREEN}2${NC}) ⏹️  Stop Web Portal"
        echo -e "  ${GREEN}3${NC}) 🔄 Restart Web Portal"
        echo -e "  ${GREEN}4${NC}) 📊 View Portal Status"
        echo -e "  ${GREEN}5${NC}) 🔙 Back to Main Menu"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-5]: ${NC}\c"
        read choice

        case $choice in
            1) start_web_portal ;;
            2) stop_web_portal ;;
            3) restart_web_portal ;;
            4) view_portal_status ;;
            5) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Web Portal Control Functions
start_web_portal() {
    echo ""
    echo -e "${YELLOW}Starting web portal...${NC}"
    sudo systemctl start "$SERVICE_NAME"
    sleep 3
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo -e "${GREEN}✅ Web portal started successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to start web portal${NC}"
        echo -e "${YELLOW}Check the service status with: sudo systemctl status $SERVICE_NAME${NC}"
    fi
    sleep 2
}

stop_web_portal() {
    echo ""
    echo -e "${YELLOW}Stopping web portal...${NC}"
    sudo systemctl stop "$SERVICE_NAME"
    sleep 2
    if ! systemctl is-active --quiet "$SERVICE_NAME"; then
        echo -e "${GREEN}✅ Web portal stopped successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to stop web portal${NC}"
    fi
    sleep 2
}

restart_web_portal() {
    echo ""
    echo -e "${YELLOW}Restarting web portal...${NC}"
    sudo systemctl restart "$SERVICE_NAME"
    sleep 3
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo -e "${GREEN}✅ Web portal restarted successfully!${NC}"
    else
        echo -e "${RED}❌ Failed to restart web portal${NC}"
    fi
    sleep 2
}

view_portal_status() {
    echo ""
    echo -e "${YELLOW}Web Portal Status:${NC}"
    sudo systemctl status "$SERVICE_NAME" --no-pager -l
    echo ""
    echo -e "${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Service Control Menu
service_control_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🔧 Service Control${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 🐳 Docker Service Control"
        echo -e "  ${GREEN}2${NC}) 🔗 Tailscale Service Control"
        echo -e "  ${GREEN}3${NC}) ⚙️  Cockpit Service Control"
        echo -e "  ${GREEN}4${NC}) 🔧 System Services"
        echo -e "  ${GREEN}5${NC}) 🔙 Back to Main Menu"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-5]: ${NC}\c"
        read choice

        case $choice in
            1) docker_control_menu ;;
            2) tailscale_control_menu ;;
            3) cockpit_control_menu ;;
            4) system_services_menu ;;
            5) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Docker Control Menu
docker_control_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🐳 Docker Service Control${NC}"
        echo ""
        
        if command -v docker &> /dev/null; then
            echo -n "Docker Service: "; check_service_status "docker"
            echo ""
            echo -e "Containers:"
            sudo docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | head -10
            echo ""
        else
            echo -e "${RED}Docker is not installed${NC}"
            echo ""
        fi
        
        echo -e "  ${GREEN}1${NC}) 🚀 Start Docker"
        echo -e "  ${GREEN}2${NC}) ⏹️  Stop Docker"
        echo -e "  ${GREEN}3${NC}) 🔄 Restart Docker"
        echo -e "  ${GREEN}4${NC}) 📊 Docker System Info"
        echo -e "  ${GREEN}5${NC}) 🗑️  Prune Docker System"
        echo -e "  ${GREEN}6${NC}) 🔙 Back"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-6]: ${NC}\c"
        read choice

        case $choice in
            1) sudo systemctl start docker; echo -e "${GREEN}✅ Docker started${NC}"; sleep 2 ;;
            2) sudo systemctl stop docker; echo -e "${GREEN}✅ Docker stopped${NC}"; sleep 2 ;;
            3) sudo systemctl restart docker; echo -e "${GREEN}✅ Docker restarted${NC}"; sleep 2 ;;
            4) sudo docker system info; echo -e "\n${YELLOW}Press [Enter] to continue...${NC}\c"; read ;;
            5) sudo docker system prune -f; echo -e "${GREEN}✅ Docker system pruned${NC}"; sleep 2 ;;
            6) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Tailscale Control Menu
tailscale_control_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🔗 Tailscale Service Control${NC}"
        echo ""
        
        if command -v tailscale &> /dev/null; then
            echo -n "Tailscale Service: "; check_service_status "tailscaled"
            echo ""
            echo -e "Tailscale Status:"
            sudo tailscale status 2>/dev/null || echo "Not connected to network"
            echo ""
        else
            echo -e "${RED}Tailscale is not installed${NC}"
            echo ""
        fi
        
        echo -e "  ${GREEN}1${NC}) 🚀 Start Tailscale"
        echo -e "  ${GREEN}2${NC}) ⏹️  Stop Tailscale"
        echo -e "  ${GREEN}3${NC}) 🔄 Restart Tailscale"
        echo -e "  ${GREEN}4${NC}) 🔗 Connect to Network"
        echo -e "  ${GREEN}5${NC}) 🔌 Disconnect from Network"
        echo -e "  ${GREEN}6${NC}) 🔙 Back"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-6]: ${NC}\c"
        read choice

        case $choice in
            1) sudo systemctl start tailscaled; echo -e "${GREEN}✅ Tailscale started${NC}"; sleep 2 ;;
            2) sudo systemctl stop tailscaled; echo -e "${GREEN}✅ Tailscale stopped${NC}"; sleep 2 ;;
            3) sudo systemctl restart tailscaled; echo -e "${GREEN}✅ Tailscale restarted${NC}"; sleep 2 ;;
            4) 
                echo -e "Enter auth key: \c"
                read auth_key
                if [[ -n "$auth_key" ]]; then
                    sudo tailscale up --auth-key "$auth_key"
                    echo -e "${GREEN}✅ Connected to Tailscale network${NC}"
                else
                    echo -e "${RED}❌ No auth key provided${NC}"
                fi
                sleep 2
                ;;
            5) sudo tailscale down; echo -e "${GREEN}✅ Disconnected from Tailscale network${NC}"; sleep 2 ;;
            6) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Cockpit Control Menu
cockpit_control_menu() {
    while true; do
        show_header
        echo -e "${CYAN}⚙️  Cockpit Service Control${NC}"
        echo ""
        
        if systemctl list-unit-files | grep -q cockpit; then
            echo -n "Cockpit Service: "; check_service_status "cockpit.socket"
            echo ""
        else
            echo -e "${RED}Cockpit is not installed${NC}"
            echo ""
        fi
        
        echo -e "  ${GREEN}1${NC}) 🚀 Start Cockpit"
        echo -e "  ${GREEN}2${NC}) ⏹️  Stop Cockpit"
        echo -e "  ${GREEN}3${NC}) 🔄 Restart Cockpit"
        echo -e "  ${GREEN}4${NC}) 🔙 Back"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-4]: ${NC}\c"
        read choice

        case $choice in
            1) sudo systemctl start cockpit.socket; echo -e "${GREEN}✅ Cockpit started${NC}"; sleep 2 ;;
            2) sudo systemctl stop cockpit.socket; echo -e "${GREEN}✅ Cockpit stopped${NC}"; sleep 2 ;;
            3) sudo systemctl restart cockpit.socket; echo -e "${GREEN}✅ Cockpit restarted${NC}"; sleep 2 ;;
            4) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# System Services Menu
system_services_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🔧 System Services${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 📋 List All Services"
        echo -e "  ${GREEN}2${NC}) 🔍 Check Service Status"
        echo -e "  ${GREEN}3${NC}) 🚀 Start Service"
        echo -e "  ${GREEN}4${NC}) ⏹️  Stop Service"
        echo -e "  ${GREEN}5${NC}) 🔄 Restart Service"
        echo -e "  ${GREEN}6${NC}) 🔙 Back"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-6]: ${NC}\c"
        read choice

        case $choice in
            1) 
                echo ""
                systemctl list-units --type=service --no-pager | head -20
                echo -e "\n${YELLOW}... (showing first 20 services)${NC}"
                echo -e "\n${YELLOW}Press [Enter] to continue...${NC}\c"
                read
                ;;
            2)
                echo -e "Enter service name: \c"
                read service_name
                if [[ -n "$service_name" ]]; then
                    echo ""
                    systemctl status "$service_name" --no-pager -l
                    echo -e "\n${YELLOW}Press [Enter] to continue...${NC}\c"
                    read
                fi
                ;;
            3)
                echo -e "Enter service name to start: \c"
                read service_name
                if [[ -n "$service_name" ]]; then
                    sudo systemctl start "$service_name"
                    echo -e "${GREEN}✅ Service $service_name started${NC}"
                    sleep 2
                fi
                ;;
            4)
                echo -e "Enter service name to stop: \c"
                read service_name
                if [[ -n "$service_name" ]]; then
                    sudo systemctl stop "$service_name"
                    echo -e "${GREEN}✅ Service $service_name stopped${NC}"
                    sleep 2
                fi
                ;;
            5)
                echo -e "Enter service name to restart: \c"
                read service_name
                if [[ -n "$service_name" ]]; then
                    sudo systemctl restart "$service_name"
                    echo -e "${GREEN}✅ Service $service_name restarted${NC}"
                    sleep 2
                fi
                ;;
            6) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Logs Menu
logs_menu() {
    while true; do
        show_header
        echo -e "${CYAN}📋 View Logs${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 📄 Web Portal Logs"
        echo -e "  ${GREEN}2${NC}) 🐳 Docker Logs"
        echo -e "  ${GREEN}3${NC}) 🔗 Tailscale Logs"
        echo -e "  ${GREEN}4${NC}) ⚙️  Cockpit Logs"
        echo -e "  ${GREEN}5${NC}) 📊 System Logs"
        echo -e "  ${GREEN}6${NC}) 🔍 Real-time Logs"
        echo -e "  ${GREEN}7${NC}) 🔙 Back to Main Menu"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-7]: ${NC}\c"
        read choice

        case $choice in
            1) view_web_portal_logs ;;
            2) view_docker_logs ;;
            3) view_tailscale_logs ;;
            4) view_cockpit_logs ;;
            5) view_system_logs ;;
            6) realtime_logs_menu ;;
            7) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Log viewing functions
view_web_portal_logs() {
    echo ""
    echo -e "${YELLOW}Web Portal Logs:${NC}"
    sudo journalctl -u "$SERVICE_NAME" --no-pager -n 20
    echo -e "\n${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

view_docker_logs() {
    echo ""
    echo -e "${YELLOW}Docker Containers:${NC}"
    sudo docker ps -a --format "table {{.Names}}\t{{.Status}}"
    echo ""
    echo -e "Enter container name to view logs (or press Enter for all): \c"
    read container
    if [[ -n "$container" ]]; then
        echo ""
        sudo docker logs "$container" --tail 20 2>/dev/null || echo -e "${RED}Container not found or no logs${NC}"
    else
        echo ""
        sudo docker logs --tail 5 2>/dev/null || echo -e "${RED}No Docker logs available${NC}"
    fi
    echo -e "\n${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

view_tailscale_logs() {
    echo ""
    echo -e "${YELLOW}Tailscale Logs:${NC}"
    sudo journalctl -u tailscaled --no-pager -n 20
    echo -e "\n${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

view_cockpit_logs() {
    echo ""
    echo -e "${YELLOW}Cockpit Logs:${NC}"
    sudo journalctl -u cockpit --no-pager -n 20
    echo -e "\n${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

view_system_logs() {
    echo ""
    echo -e "${YELLOW}System Logs (last 20 entries):${NC}"
    sudo journalctl --no-pager -n 20
    echo -e "\n${YELLOW}Press [Enter] to continue...${NC}\c"
    read
}

# Real-time Logs Menu
realtime_logs_menu() {
    while true; do
        show_header
        echo -e "${CYAN}🔍 Real-time Logs${NC}"
        echo ""
        echo -e "  ${GREEN}1${NC}) 📄 Web Portal (follow)"
        echo -e "  ${GREEN}2${NC}) 🐳 Docker (follow)"
        echo -e "  ${GREEN}3${NC}) 🔗 Tailscale (follow)"
        echo -e "  ${GREEN}4${NC}) ⚙️  Cockpit (follow)"
        echo -e "  ${GREEN}5${NC}) 📊 System (follow)"
        echo -e "  ${GREEN}6${NC}) 🔙 Back"
        echo ""
        echo -e "${YELLOW}Enter your choice [1-6]: ${NC}\c"
        read choice

        case $choice in
            1) sudo journalctl -u "$SERVICE_NAME" -f ;;
            2) 
                echo -e "Enter container name (or press Enter for all): \c"
                read container
                if [[ -n "$container" ]]; then
                    sudo docker logs "$container" -f 2>/dev/null || echo -e "${RED}Container not found${NC}"
                else
                    sudo docker logs -f 2>/dev/null || echo -e "${RED}No Docker containers running${NC}"
                fi
                ;;
            3) sudo journalctl -u tailscaled -f ;;
            4) sudo journalctl -u cockpit -f ;;
            5) sudo journalctl -f ;;
            6) break ;;
            *) echo -e "\n${RED}Invalid option!${NC}"; sleep 2 ;;
        esac
    done
}

# Reboot Menu
reboot_menu() {
    show_header
    echo -e "${CYAN}🔄 Reboot System${NC}"
    echo ""
    echo -e "${YELLOW}This will reboot the system.${NC}"
    echo ""
    echo -e "Are you sure you want to reboot? (y/N): \c"
    read confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${YELLOW}Rebooting system...${NC}"
        sleep 2
        sudo reboot
    else
        echo -e "${GREEN}Reboot cancelled.${NC}"
        sleep 2
    fi
}

# ===============================================
# Initialization and Main Execution
# ===============================================

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}Error: Do not run this script as root.${NC}"
    echo -e "${YELLOW}Run as a regular user with sudo privileges.${NC}"
    exit 1
fi

# Check sudo privileges
if ! sudo -n true 2>/dev/null; then
    echo -e "${YELLOW}Enter your password for sudo access:${NC}"
    if ! sudo -v; then
        echo -e "${RED}Error: Sudo access required.${NC}"
        exit 1
    fi
fi

# Update sudo timestamp
sudo -v

# Set trap to handle Ctrl+C
trap 'echo -e "\n\n${YELLOW}Exiting GEN2 Menu...${NC}"; exit 0' INT

# Start the main menu
main_menu