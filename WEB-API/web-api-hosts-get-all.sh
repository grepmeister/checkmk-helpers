#!/usr/bin/env bash

# 2025-09-03 Y0d0g MiMiMi <github@stippmilch.de>

# if you need the attributes from folder inheritance as well
effective_attributes=${1:-0}

# secret
read -r secret <~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# query the web api
curl \
  --silent \
  --header "Authorization: Bearer automation $secret" \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/webapi.py?action=get_all_hosts&_username=automation&_secret=${secret}&effective_attributes=${effective_attributes}" |
  jq ''
