#!/usr/bin/env bash

# rest-api-hostgroups-by-query2.sh | jq -r '.value[].extensions | "\(.name) \(.groups | join (","))"' | column -t | sort -k2
# host1             hgMyServers
# host2             hgMyServers
# switch1           hgMyServers,hgMySwitches

# secret
read secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# site user is used for site and folder 
site="$USER"

# query rest api
curl \
  --get \
  --silent \
  --header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --data-urlencode 'columns=name' \
  --data-urlencode 'columns=groups' \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/host/collections/all"   \
  | jq 'del(.links) | del (.value[].links)'  \
  | jq -r '.value[].extensions | "\(.name) \(.groups | join (","))"' | column -t | sort -k2
