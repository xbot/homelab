#!/bin/bash
###############################################################################################
# Backup essential data to PBS.
#
# Be sure to initialize PBS_REPOSITORY, PBS_PASSWORD, PBS_NAMESPACE in /root/.profile before 
# executing this script.
#
# References:
# - https://pve.proxmox.com/wiki/Proxmox_VE_4.x_Cluster#Re-installing_a_cluster_node
###############################################################################################

TEMP_DIR="/tmp/proxmox_backup_temp"

if [ -f /root/.profile ]; then
    source /root/.profile
else
    echo ".profile is missing." >&2
    exit 1
fi

if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

mkdir -p "$TEMP_DIR"

cp /etc/hosts "$TEMP_DIR/"
cp /etc/network/interfaces "$TEMP_DIR/"
cp /var/lib/pve-cluster/config.db "$TEMP_DIR/"
cp /root/.profile "$TEMP_DIR/"
cp -r /etc/corosync "$TEMP_DIR/"
cp -r /root/.ssh "$TEMP_DIR/"

crontab -l > "$TEMP_DIR/crontab"

proxmox-backup-client backup pve.pxar:"$TEMP_DIR" --ns "$PBS_NAMESPACE"

rm -rf "$TEMP_DIR"
