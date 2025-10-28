#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="/tmp/vpn_manager"
mkdir -p "$STATE_DIR"

timestamp(){ date +"%Y-%m-%d %H:%M:%S"; }

list_ifaces(){ ip -o link show | awk -F': ' '{print $2}'; }

change_mac_random(){
  read -rp "Interface: " ifc
  sudo ip link set "$ifc" down
  sudo macchanger -r "$ifc"
  sudo ip link set "$ifc" up
}

change_mac_manual(){
  read -rp "Interface: " ifc
  read -rp "New MAC: " mac
  sudo ip link set "$ifc" down
  sudo macchanger -m "$mac" "$ifc"
  sudo ip link set "$ifc" up
}

restore_mac(){
  read -rp "Interface: " ifc
  sudo macchanger -p "$ifc"
}
#AdrianStudio
start_openvpn(){
  read -rp "Path to .ovpn file: " file
  sudo openvpn --config "$file" &
  echo $! > "$STATE_DIR/openvpn.pid"
  echo "OpenVPN started (PID $(cat "$STATE_DIR/openvpn.pid"))"
}

stop_openvpn(){
  if [ -f "$STATE_DIR/openvpn.pid" ]; then
    sudo kill "$(cat "$STATE_DIR/openvpn.pid")" && rm -f "$STATE_DIR/openvpn.pid"
    echo "OpenVPN stopped."
  else
    echo "No OpenVPN PID file."
  fi
