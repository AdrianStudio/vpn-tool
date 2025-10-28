# REQUIREMENTS & SETUP

This file explains how to prepare your Kali VM for **vpn-tool**, including installing packages, downloading VPNBook configs, and renaming files so the script finds them automatically.

---

## 1. Install required packages (Kali Linux)

Run these commands to install needed tools:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y openvpn macchanger curl net-tools unzip
```

Verify OpenVPN is installed:
```bash
openvpn --version
```

Enable the TUN kernel module (required for OpenVPN):
```bash
sudo modprobe tun
```

---

## 2. Create configuration folder

Create the folder where `vpn.sh` expects OpenVPN profiles:
```bash
mkdir -p ~/vpn_configs/openvpn
```

---

## 3. Download VPNBook configs (example)

Use VPNBook (free) as a test provider. This downloads the current ZIP of OpenVPN configs and extracts them into the config folder:

```bash
cd ~/vpn_configs/openvpn
# download (example US bundle)
curl -LO https://www.vpnbook.com/free-openvpn-files/US1.zip
# unzip and remove the archive
unzip US1.zip
rm US1.zip
```

Repeat for other bundles if you want more regions (US2, EU, etc.) — adjust the zip name accordingly.

> Note: VPNBook rotates credentials weekly. Visit https://www.vpnbook.com/freevpn to get the current username and password.

---

## 4. Rename the files the script expects

The `vpn.sh` script uses the following filenames for the country menu:
```
usa.ovpn
uk.ovpn
germany.ovpn
france.ovpn
canada.ovpn
```

From the extracted VPNBook files, pick one .ovpn per country and rename it. Example commands:

```bash
cd ~/vpn_configs/openvpn

# Example: rename VPNBook files to the script's expected names
mv vpnbook-us16-tcp80.ovpn usa.ovpn       # use the file matching the US server you prefer
mv vpnbook-uk205-tcp443.ovpn uk.ovpn
mv vpnbook-de20-udp53.ovpn germany.ovpn
mv vpnbook-fr200-udp25000.ovpn france.ovpn
mv vpnbook-ca149-tcp80.ovpn canada.ovpn
```

Adjust filenames to match the actual files you downloaded — use `ls` to see exact names.

---

## 5. (Optional) Save credentials for automatic login

Create an `auth.txt` file with two lines: username on the first line, password on the second:

```bash
nano ~/vpn_configs/openvpn/auth.txt
# put:
# vpnbook
# CURRENT_PASSWORD_FROM_VPNBOOK
```

Then edit each `.ovpn` you will use and add (or edit) this line:
```
auth-user-pass /home/kali/vpn_configs/openvpn/auth.txt
```

This allows OpenVPN to log in without prompting.

---

## 6. Make the script executable

If you placed `vpn.sh` in your repo folder, make it executable:
```bash
chmod +x ~/path/to/vpn.sh
```

Run the tool with preserved HOME (recommended):
```bash
sudo -E ~/path/to/vpn.sh
```

---

## Troubleshooting

- If you see `AUTH_FAILED` in the OpenVPN log, credentials are wrong — get the latest from https://www.vpnbook.com/freevpn.
- If `tun0` does not appear after connecting, ensure `sudo modprobe tun` ran successfully.
- If OpenVPN fails due to cipher errors, the config may be outdated — download the latest bundle.

---

## Quick verification

1. Start the VPN with the script (option 5).  
2. Check the tunnel interface:
```bash
ip a | grep tun0
```
3. Verify external IP changed:
```bash
curl ifconfig.me
```

---

© 2025 AdrianStudio
