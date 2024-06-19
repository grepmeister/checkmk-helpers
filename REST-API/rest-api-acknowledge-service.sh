#!/usr/bin/env bash

# 2024-06-19 Grepmeister <grepmeister@stippmilch.de>
# to be run as site user

# secret
read -r secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# activate changes
curl -X 'POST' \
	--silent \
	"http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/acknowledge/collections/service" \
	--header 'Accept: application/json' \
	--header "Authorization: Bearer automation $secret" \
	--header 'Content-Type: application/json' \
	--header 'If-Match: *' \
	--data '{
	"acknowledge_type": "service",
	"sticky": false,
	"persistent": true,
	"notify": false,
	"comment": "this is my comment",
	"host_name": "'${host}'",
	"service_description": "'${service}'"
}' \
| jq 'del(.links)' 
