#/bin/bash
# Alters mac Firewall to remove the cisco "deny ip from any ip rule"
# ./cisco.workaround.sh
printf "Asking for root access to remove Cisco IP Blocking rule\n"
sudo ipfw -a list | grep "deny ip from any to any" | awk '{ print $1}' | xargs -0 sudo ipfw delete
