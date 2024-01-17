#!/usr/bin/env bash

# secret
read -r secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# site user is used for site and folder 
site="$USER"

# query rest api
curl \
	--silent \
  -G \
  --request GET \
	--header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data-urlencode 'columns=check_command' \
  --data-urlencode 'columns=description' \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/service/collections/all" \
| jq 'del(.links) | del(.value[].links)' \
| jq -r '.value[].extensions.description'
