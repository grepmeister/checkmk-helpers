#!/usr/bin/env bash

# run as site user

# secret
read secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

curl \
  --silent \
  --request 'DELETE' \
  "http://${CONFIG_APACHE_TCP_ADDR}/${OMD_SITE}/check_mk/api/1.0/objects/host_config/${1}" \
  --header 'accept: */*' \
  --header "Authorization: Bearer automation ${secret}"
