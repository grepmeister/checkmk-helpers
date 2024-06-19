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
	--silent \
	--header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
	--data '{
			"attributes": {
        "site": "'$site'",
      	"tag_piggyback": "no-piggyback",
      	"tag_address_family": "no-ip"
			},
			"parent": "/",
			"name": "'$folder'",
			"title": "'$folder'"
		}' \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/folder_config/collections/all" \
| jq 'del(.links)' 
