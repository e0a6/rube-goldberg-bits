#!/bin/bash

export DISPLAY=:0

session=$(curl --head 'https://scheduler.itialb4dmv.com/schAlberta' \
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

calgaryResult=$(curl --cookie $session_token_raw --max-time 90 'https://scheduler.itialb4dmv.com/SchAlberta/Appointment/Search' \
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
  --data-raw 'ServiceGroupID=7&LocationName=&PostalCode=&PostalCodeRadius=25&CityName=Calgary&CityNameRadius=100&apid=' \
  --compressed ;)

echo "$calgaryResult"

# Tokens
noneAvailableToken="No available appointment slots found for the selected criteria."
downMaintenanceToken="Please check below for maintenance window hours."
errorToken="Error - Alberta Road Test System"
availableToken="<span id=\"locationName"

# Static
notificationTitle="Alberta Road Test General"

currentTime=$(date +'%H:%M:%S')

if grep -q "$downMaintenanceToken" <<< "$calgaryResult"; then
	#/usr/bin/notify-send -t 5000 "$notificationTitle" "$currentTime \n Down for maintenance"
	/usr/bin/notify-send -t 5000 "$notificationTitle" "$currentTime \n Down for maintenance"
	sleep 1
elif grep -q "$noneAvailableToken" <<< "$calgaryResult"; then
	/usr/bin/notify-send -t 5000 "$notificationTitle" "$currentTime \n None Available"
	sleep 1
elif grep -q "$errorToken" <<< "$calgaryResult"; then
	/usr/bin/notify-send -t 5000 "$notificationTitle" "$currentTime \n Error in Alberta System"
elif grep -q "$availableToken" <<< "$calgaryResult"; then
	locations=$(grep "$availableToken" <<< "$calgaryResult")
	/usr/bin/notify-send -t 30000 "$notificationTitle" "$currentTime \n $locations"
fi

