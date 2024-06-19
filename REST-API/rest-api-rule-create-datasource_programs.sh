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
	--silent \
	--header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
	--data '{
  "ruleset": "datasource_programs",
  "folder": "/'${folder}'",
  "properties": {
    "description": "my '$folder' description",
    "comment": "my '$folder' comment\n",
    "disabled": false
  },
  "value_raw": "'\''/usr/local/bin/my-service.sh 3'\''",
  "conditions": {
    "host_tags": [],
    "host_labels": [],
    "service_labels": []
  }
}' \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/rule/collections/all" \
  | jq 'del(.links)'

#  "value_raw": "'/usr/local/bin/my-service.sh 5'",
