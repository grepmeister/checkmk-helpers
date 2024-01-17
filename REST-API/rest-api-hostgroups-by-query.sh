#!/usr/bin/env bash

# secret
read -r secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# site user is used for site and folder 
site="$USER"

# query rest api
curl \
  -G \
	--silent \
	--header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --data-urlencode 'query={"op": ">=", "left": "hosts.groups", "right": "hgMyServers"}' \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/host/collections/all"   \
| jq 'del(.links)' 
