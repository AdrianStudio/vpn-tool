# Requirements 🧰

Follow these steps to install everything needed to run **vpn-tool** on Kali Linux.

## Installation Steps 🧩

### 1️⃣ Update your system
```bash
sudo apt update && sudo apt upgrade -y
```

### 2️⃣ Install required packages
```bash
sudo apt install openvpn macchanger curl net-tools -y
```

### 3️⃣ Enable the TUN module (required for VPN)
```bash
sudo modprobe tun
```

### 4️⃣ (Optional) Check if tun is loaded
```bash
ip a | grep tun0
```

### 5️⃣ Verify OpenVPN works
```bash
sudo openvpn --version
```

You’re now ready to run the script!
