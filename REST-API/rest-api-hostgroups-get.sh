#!/usr/bin/env bash

# host
host=$1

# secret
read -r secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# site user is used for site and folder 
site="$USER"

# query rest api
curl \
	--silent \
	--header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/host_group_config/collections/all" \
| jq 'del(.links)' 
