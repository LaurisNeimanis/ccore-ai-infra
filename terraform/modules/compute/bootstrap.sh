#!/bin/bash
set -euo pipefail

# --------------------------------------------
# BASELINE BOOTSTRAP SCRIPT FOR EC2
# Prepares instance for Ansible provisioning
# --------------------------------------------

# 1. Update APT cache
apt-get update -y

# 2. Install Python (required by Ansible)
apt-get install -y python3

# 3. Ensure OpenSSH server exists (Ubuntu cloud images usually have it)
if ! systemctl status ssh >/dev/null 2>&1; then
    apt-get install -y openssh-server
    systemctl enable ssh
    systemctl start ssh
fi

# 4. Marker file to confirm bootstrap completion
echo "$(date '+%F %T') Bootstrap completed" | tee /var/log/bootstrap_ready.log
