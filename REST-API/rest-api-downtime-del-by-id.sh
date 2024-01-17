#!/usr/bin/env bash

# id
id=$1

if [ -z "$id" ]
then
  echo "usage: $0 <id>"
  exit 1
fi

# secret
read -r secret < ~/var/check_mk/web/automation/automation.secret

# ip & port
source ~/etc/omd/site.conf

# site user is used for site and folder 
site="$USER"

# query rest api
curl \
	--silent \
  --request POST \
	--header "Authorization: Bearer automation $secret" \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --data '{
        "delete_type": "by_id",
        "downtime_id": "'$id'"
      }' \
  "http://${CONFIG_APACHE_TCP_ADDR}:${CONFIG_APACHE_TCP_PORT}/${OMD_SITE}/check_mk/api/1.0/domain-types/downtime/actions/delete/invoke"
