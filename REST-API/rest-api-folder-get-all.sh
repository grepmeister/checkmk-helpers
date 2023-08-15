#!/usr/bin/env bash

# 2023-05-08 Jodok Ole Glabasna <jodok.glabasna@checkmk.com>

# Show all sub-folders of this folder. The default is the root-folder.
parent=${1:-/}

# List the folder (default: root) and all its sub-folders recursively. 
recursive=${2:-false}

# secret
read secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# query the rest api
curl \
	--silent \
	--header "Authorization: Bearer automation $secret" \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/folder_config/collections/all?parent=${parent}&recursive=${recursive}" \
| jq 'del(.links) | del(.value[].links)'
