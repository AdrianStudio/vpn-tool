# REQUIREMENTS & INSTALLATION COMMANDS

This file shows how to install the packages required by **vpn-tool**. Copy and paste the commands for your distribution.

**Packages used by vpn-tool**
- `openvpn` — OpenVPN client (for .ovpn profiles)  
- `wireguard` / `wireguard-tools` — WireGuard client and `wg-quick`  
- `macchanger` — change and restore MAC addresses  
- `net-tools` — (optional) network utilities like `ifconfig` (useful)  
- `iptables` — used by the killswitch script (`vpnks`)  
- `git` — to clone the repository

---

## Debian / Ubuntu / Kali (APT)
```bash
sudo apt update
sudo apt install -y openvpn wireguard macchanger net-tools iptables git
```

Verify installed binaries:
```bash
openvpn --version
wg --version
macchanger --version
ifconfig --version || ip addr show
iptables --version
git --version
```

---

## Fedora (DNF)
```bash
sudo dnf install -y openvpn wireguard-tools macchanger net-tools iptables git
```

Verify:
```bash
openvpn --version
wg --version
macchanger --help
ifconfig --version || ip addr show
sudo iptables --version
git --version
```

---

## Arch Linux / Manjaro (Pacman)
```bash
sudo pacman -Sy --noconfirm openvpn wireguard-tools macchanger net-tools iptables git
```

Verify:
```bash
openvpn --version
wg --version
macchanger --help
ifconfig --version || ip addr show
iptables --version
git --version
```

---

## OpenWRT / Embedded (opkg) — example (may vary)
```bash
opkg update
opkg install openvpn-openssl wireguard-tools kmod-mac80211 macchanger net-tools iptables git
```

---

## Notes and common issues

### WireGuard on older kernels
If `wg-quick` or `wireguard` is not available on older kernels you may need to install kernel headers or compile the module. On Debian/Ubuntu:
```bash
sudo apt install linux-headers-$(uname -r) build-essential
sudo apt install wireguard-dkms wireguard-tools
```

### Running as root
Many commands require root. Use `sudo` where shown.

### If `wg-quick up` fails
Try copying the WireGuard config to `/etc/wireguard/` and running:
```bash
sudo cp ~/vpn_configs/wg/yourfile.conf /etc/wireguard/
sudo wg-quick up yourfile
```

### If `openvpn` needs credentials
Some `.ovpn` files require an `auth-user-pass` file. Check the `.ovpn` or provider docs and create a `creds.txt` file with:
```
username
password
```
Then reference it inside the `.ovpn` or run:
```bash
sudo openvpn --config /path/to/file.ovpn --auth-user-pass /path/to/creds.txt
```

---

## Verifying network tools are available
A quick check script:
```bash
#!/usr/bin/env bash
set -e
for cmd in openvpn wg macchanger ifconfig ip iptables git; do
  printf "%-10s -> " "$cmd"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "MISSING"
  fi
done
```
Save as `check-requirements.sh`, `chmod +x check-requirements.sh` and run with `./check-requirements.sh`.

---

## Final notes
- Use the package manager native to your distribution.  
- If you are using a VM (recommended for pentesting), update packages inside the VM itself.  
- If you need a step-by-step for any specific distribution, tell me which one and I will add it.
