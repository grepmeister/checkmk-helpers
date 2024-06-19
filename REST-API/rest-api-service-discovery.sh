#!/usr/bin/env bash

# 2024-06-19 Grepmeister <grepmeister@stippmilch.de>

# secret
read -r secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# site user is used for site and folder 
folder="$USER"
site="$USER"

# query the rest api
curl \
  --request POST \
	--verbose \
	--header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{ "mode": "refresh" }' \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/objects/host/host-on-${site}/actions/discover_services/invoke" \
| jq 'del(.links)'

#  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/service_discovery_run/actions/start/invoke" \
