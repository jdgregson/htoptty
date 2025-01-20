#!/bin/bash
set -euo pipefail

USE_TTY=7
SCRIPT_PATH=/usr/local/bin/htoptty
USE_USER=htoptty

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

if ! command -v htop >/dev/null 2>&1; then
    echo "htop is not installed"
    exit 1
fi

curl -f -l "https://raw.githubusercontent.com/jdgregson/htoptty/refs/heads/master/src/htoptty" -o $SCRIPT_PATH
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Failed to download htoptty script"
    exit 1
fi
chmod +x $SCRIPT_PATH

useradd -r -s /sbin/nologin $USE_USER
usermod -a -G tty $USE_USER
chmod g+rw /dev/tty$USE_TTY

cat >/etc/udev/rules.d/70-tty$USE_TTY-permissions.rules << EOF
KERNEL=="tty$USE_TTY", MODE="0660", GROUP="tty"
EOF

cat > /etc/systemd/system/htoptty.service << EOF
[Unit]
Description=Run htop on a TTY.
After=multi-user.target
Conflicts=getty@tty$USE_TTY.service
ConditionPathExists=/dev/tty$USE_TTY

[Service]
Type=simple
ExecStart=$SCRIPT_PATH $USE_TTY
StandardInput=null
StandardOutput=tty
TTYPath=/dev/tty$USE_TTY
StandardError=tty
User=$USE_USER
Group=tty
Restart=always
RestartSec=0
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable htoptty.service
systemctl start htoptty.service

echo "htoptty installed and started."
echo "Switch to tty$USE_TTY to view."
