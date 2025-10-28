#!/bin/bash

LOG_DIR="/tmp/vpn_manager/logs"
PID_DIR="/tmp/vpn_manager/pids"
mkdir -p "$LOG_DIR" "$PID_DIR"

OPENVPN_DIR="/home/kali/vpn_configs/openvpn"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="$LOG_DIR/openvpn-$TIMESTAMP.log"
PID_FILE="$PID_DIR/openvpn.pid"

function log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

function list_interfaces() {
    ip link show | awk -F': ' '/^[0-9]+: /{print $2}'
}

function random_mac() {
    read -p "Enter interface: " interface
    sudo ip link set "$interface" down
    sudo macchanger -r "$interface"
    sudo ip link set "$interface" up
    log "Randomized MAC on $interface"
}

function manual_mac() {
    read -p "Enter interface: " interface
    read -p "Enter new MAC address: " new_mac
    sudo ip link set "$interface" down
    sudo macchanger --mac="$new_mac" "$interface"
    sudo ip link set "$interface" up
    log "Manual MAC set on $interface: $new_mac"
}

function restore_mac() {
    read -p "Enter interface: " interface
    sudo ip link set "$interface" down
    sudo macchanger -p "$interface"
    sudo ip link set "$interface" up
    log "Restored original MAC on $interface"
}

function start_openvpn() {
    echo -e "\nAvailable countries:"
    echo "1) USA"
    echo "2) UK"
    echo "3) GERMANY"
    echo "4) FRANCE"
    echo "5) CANADA"
    read -p "Select country number: " choice

    case $choice in
        1) config="$OPENVPN_DIR/usa.ovpn" ;;
        2) config="$OPENVPN_DIR/uk.ovpn" ;;
        3) config="$OPENVPN_DIR/germany.ovpn" ;;
        4) config="$OPENVPN_DIR/france.ovpn" ;;
        5) config="$OPENVPN_DIR/canada.ovpn" ;;
        *) echo "Invalid option"; return ;;
    esac

    if [ ! -f "$config" ]; then
        echo "[!] File not found: $config"
        return
    fi

    log "Starting OpenVPN with $config"
    sudo openvpn --config "$config" --daemon --writepid "$PID_FILE" --log "$LOG_FILE" || {
        echo "[ERROR] Failed to start OpenVPN"
        return 1
    }
    log "OpenVPN started (PID file: $PID_FILE)"
    echo
    read -p "Press ENTER to continue..."
}

function stop_openvpn() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            sudo kill "$pid"
            log "Stopped OpenVPN (PID $pid)"
        fi
        rm -f "$PID_FILE"
    else
        echo "[!] No OpenVPN process found"
    fi
}

while true; do
    echo "——— VPN & MAC Manager ———"
    echo "1) List interfaces"
    echo "2) Random MAC"
    echo "3) Manual MAC"
    echo "4) Restore MAC"
    echo "5) Start OpenVPN"
    echo "6) Stop OpenVPN"
    echo "7) Exit"
    echo "———————————————"
    read -p "Select option: " option

    case $option in
        1) list_interfaces ;;
        2) random_mac ;;
        3) manual_mac ;;
        4) restore_mac ;;
        5) start_openvpn ;;
        6) stop_openvpn ;;
        7) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option!" ;;
    esac
done
