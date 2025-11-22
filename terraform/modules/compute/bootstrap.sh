#!/bin/bash
set -euo pipefail

# 1. Update APT cache
apt-get update -y

# 2. Install Python (required for Ansible)
apt-get install -y python3

# 3. Ensure OpenSSH server exists (usually preinstalled on Ubuntu cloud images)
if ! systemctl status ssh >/dev/null 2>&1; then
    apt-get install -y openssh-server
    systemctl enable ssh
    systemctl start ssh
fi

# 4. Marker file to confirm bootstrap stage completed
echo "$(date '+%F %T') Bootstrap completed" | tee /var/log/bootstrap_ready.log
