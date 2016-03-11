#!/usr/bin/env bash

#
# Firewall Rules
#

echo "Opening ports required by the application..."
firewall-cmd --permanent --add-port=22/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=137/tcp
firewall-cmd --permanent --add-port=138/tcp
firewall-cmd --permanent --add-port=139/tcp
firewall-cmd --permanent --add-port=445/tcp
firewall-cmd --permanent --add-port=901/tcp
firewall-cmd --permanent --add-port=5432/tcp
firewall-cmd --permanent --add-port=8000/tcp
firewall-cmd --permanent --add-port=8001/tcp
firewall-cmd --reload