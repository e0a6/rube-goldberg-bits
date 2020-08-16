#!/bin/bash

export DISPLAY=:0

session=$(curl --silent --head 'https://scheduler.itialb4dmv.com/schAlberta' \
  -H 'authority: scheduler.itialb4dmv.com' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: none' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'accept-language: en-US,en;q=0.9' \
  --compressed ;)

session_token="$(grep -P -o '[a-z0-9]{24}' <<< $session)"
location=$(echo "$1" | sed -e "s/ /+/g")			# $1 : location with spaces

currentTime=$(date +'%H:%M:%S')
result=$(curl --silent --max-time 90 'https://scheduler.itialb4dmv.com/SchAlberta/Appointment/Search' \
  -H 'authority: scheduler.itialb4dmv.com' \
  -H 'cache-control: max-age=0' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'origin: https://scheduler.itialb4dmv.com' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'referer: https://scheduler.itialb4dmv.com/SchAlberta/Location' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H "cookie: ASP.NET_SessionId=$session_token" \
  --data-raw "ServiceGroupID=7&LocationName=$location&PostalCode=&PostalCodeRadius=25&CityName=&CityNameRadius=100&apid=" \
  --compressed ;)

# echo "$result"

# Tokens
noneAvailableToken="No availabilities were found given the selected options."
downMaintenanceToken="Please check below for maintenance window hours."
errorToken="Error - Alberta Road Test System"
availableToken="<span id=\"locationName"

# Title of the noftification
notificationTitle="Alberta Road"
#/usr/bin/notify-send --hint int:transient:1 $@
if grep -q "$downMaintenanceToken" <<< "$result"; then
	#/usr/bin/notify-send -t 5000 "$notificationTitle" "$currentTime \n Down for maintenance"
	sleep 1
elif grep -q "$noneAvailableToken" <<< "$result"; then
	#/usr/bin/notify-send -t 5000 "$notificationTitle" "$currentTime \n None Available \n $1"
	sleep 1
elif grep -q "$errorToken" <<< "$result"; then
	/usr/bin/notify-send -t 5000 "$notificationTitle" "$currentTime \n Error in Alberta System"
elif grep -q "$availableToken" <<< "$result"; then
	#locations=$(grep "$availableToken" <<< "$result")
	/usr/bin/notify-send -t 10000 "$notificationTitle" "$currentTime \n $1"
else
	/usr/bin/notify-send -t 15000 "$notificationTitle" "$currentTime \n No tokens matched (see logs) \n $1"
	# add logs if desired
	sleep 1
fi

