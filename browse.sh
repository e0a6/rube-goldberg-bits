#!/bin/bash

accounts="Main\nPro\nRich\nGuest\nMorning\n"
chosen=$(echo -e "$accounts" | rofi -dmenu -i -p "Browse as?")

# [ ] is equivalent to test
# see man test
#if [ $chosen == "Rich" ];then
if [[ $chosen == "Main" ]];then
	google-chrome --profile-directory="Default"
elif [[ $chosen == "Pro" ]];then
	google-chrome --profile-directory="Profile 1"
elif [[ $chosen == "Rich" ]];then
	google-chrome --profile-directory="Profile 2"
elif [[ $chosen == "Guest" ]];then
	google-chrome --guest --temp-profile
elif [[ $chosen == "Morning" ]];then
	google-chrome --profile-directory="Default" \
		--new-window \
		--temp-profile \
		"gmail.com" \
		"outlook.office.com" \
		"https://news.ycombinator.com" \
		"https://www.latimes.com" \
		"https://www.nytimes.com" \
		"https://www.ft.com" \
		"https://www.wsj.com"
fi

# https://askubuntu.com/questions/1230508/19141191410425-011526-129520errorsandbox-linux-cc374-initializesandbox
# test or [] is a unary operator
# if you do [ $myvar == "foo" ] and myvar is empty it will complain.
# To get around this you use [[ ]] instead of []
