#!/bin/bash

# check arguments
if [ -z "$2" ]; then
	part="0001";
	if [ -z "$1" ]; then
		page="100";
	else
		page="$1";
	fi;
else
	part="$2";
	page="$1";
fi

directory=${page::1}00
part=$(printf "%04d" "$part")

address=https://www.rtp.pt/wportal/fab-txt/texto/$directory/$page"_"$part.htm
if [ "$(curl -s -I $address|head -n1|grep -c 404)" -eq 1 ]; then
	echo "Essa página não existe, tenta a página 100, parte 0001!"
else
	elinks -dump -dump-color-mode 3 -no-references -no-numbering "$address"
	echo -e "\033[0m"
fi

# echo "DEBUG: $address"
