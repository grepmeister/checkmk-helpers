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
  --data-urlencode 'columns=name' \
  --data-urlencode 'columns=labels' \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/host/collections/all"   \
  | jq 'del(.links) | del (.value[].links)'


# Example
# rest-api-host-labels.sh cmk.jodok.tribe29.com | jq -r '.value[] |  "\(.title) \(.extensions.labels | to_entries[] | "\(.key):\(.value)" )"'
