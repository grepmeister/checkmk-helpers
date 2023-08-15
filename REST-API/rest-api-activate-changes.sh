#!/usr/bin/env bash

# 2023-05-08 Jodok Ole Glabasna <jodok.glabasna@checkmk.com>

# to be run as site user

# secret
read secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# activate changes
curl -X 'POST' \
	--silent \
	"http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/activation_run/actions/activate-changes/invoke" \
	--header 'accept: application/json' \
	--header "Authorization: Bearer automation $secret" \
	--header 'Content-Type: application/json' \
	--data '{
		"redirect": false,
		"sites": [
			"'${OMD_SITE}'"
		],
	"force_foreign_changes": true }' \
| jq 'del(.links)' 
