#!/usr/bin/env bash

# secret
read -r secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# query rest api
curl \
  --get \
  --silent \
  --header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/host_config/collections/all?effective_attributes=False"   \
| jq 'del(.links) | del (.value[].links)' \
| jq -r '.value[] | select( .extensions.is_cluster == true ) | "\(.title) \(.extensions.cluster_nodes | map(tostring) | join(",") )"' 
