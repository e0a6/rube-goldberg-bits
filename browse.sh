#!/bin/bash

accounts="Main\nPro\nRich\nDIH\nGuest\nMorning"
chosen=$(echo -e "$accounts" | dmenu -i -p "Browse as?")

# [ ] is equivalent to test
# see man test
#if [ $chosen == "Rich" ];then
if [[ $chosen == "Main" ]];then
	chromium --profile-directory="Default"
elif [[ $chosen == "Pro" ]];then
	chromium --profile-directory="Profile 6"
elif [[ $chosen == "Rich" ]];then
	chromium --profile-directory="Profile 2"
elif [[ $chosen == "DIH" ]];then
	chromium --profile-directory="Profile 1"
elif [[ $chosen == "Guest" ]];then
	chromium --guest --temp-profile
elif [[ $chosen == "Morning" ]];then
	chromium --profile-directory="Default" \
		--new-window \
		--temp-profile \
		"gmail.com" \
		"bbc.com" \
		"outlook.office.com"
fi

# https://askubuntu.com/questions/1230508/19141191410425-011526-129520errorsandbox-linux-cc374-initializesandbox
# test or [] is a unary operator
# if you do [ $myvar == "foo" ] and myvar is empty it will complain.
# To get around this you use [[ ]] instead of []
