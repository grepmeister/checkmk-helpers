#!/usr/bin/env bash

# 2024-06-19 Grepmeister <grepmeister@stippmilch.de>

# secret
read -r secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

host="$1"

# query the rest api
curl \
  --request GET \
	--silent \
	--header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/objects/service_discovery/${host}" \
| jq 'del(.links)'
