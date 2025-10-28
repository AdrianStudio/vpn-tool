# vpn-tool

**Author:** AdrianStudio  
**Repository:** `vpn-tool`  
**License:** GNU GPL v3.0

## Overview

`vpn-tool` is a small, menu-driven Bash utility for Kali Linux and other Debian-based distributions that centralizes VPN management and MAC address handling.  
It provides a simple terminal menu to:

- list network interfaces,  
- set a random or custom MAC address and restore the original MAC,  
- start/stop OpenVPN profiles (`.ovpn`), and  
- start/stop WireGuard configurations (`wg-quick`).

The tool is intended for ethical pentesting labs and local testing environments (VMs). Use responsibly and only against systems you are authorized to test.

## Features

| Feature | Description |
|---|---|
| Interface listing | Show active network interfaces (eth0, eth1, lo) |
| MAC spoofing | Random or manual MAC assignment, and restore original MAC |
| OpenVPN support | Start/stop `.ovpn` profiles |
| WireGuard support | Start/stop WireGuard configs with `wg-quick` |
| Killswitch integration | Companion `vpnks` script implements an iptables killswitch |

## License

This project is released under the **GNU General Public License v3.0 (GPL-3.0)**. See the `LICENSE` file or https://www.gnu.org/licenses/gpl-3.0.html for details.

