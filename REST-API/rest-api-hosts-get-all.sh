#!/usr/bin/env bash

# 2023-05-08 Jodok Ole Glabasna <jodok.glabasna@checkmk.com>

# if you need the attributes from folder inheritance as well
effective_attributes=${1:-False}

# secret
read secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# query the rest api
curl \
	--silent \
	--header "Authorization: Bearer automation $secret" \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/host_config/collections/all?effective_attributes=${effective_attributes}" \
| jq 'del(.links) | del(.value[].links)' \
| jq -r '.value[].id'
# you may want to alter the jq filter above 
