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
	# código de cor
	if [ -n "$3" ]; then
		if [ "$3" = "vermelho" ]; then
			cor=1;
		elif [ "$3" = "verde" ]; then
			cor=2;
		elif [ "$3" = "amarelo" ]; then
			cor=3;
		elif [ "$3" = "azul" ]; then
			cor=4;
		else
			echo "Argumento errado: o terceiro argumento tem de ser um código de cor: vermelho, verde, amarelo ou azul!";
			exit;
		fi
		dump=$(elinks -dump "$address");
		ref=$(for s in $(echo "$dump"|grep └ -B2|head -n1); do echo "$s"|grep "\["; done|cut -d\[ -f2|cut -d\] -f1|head -n$cor|tail -n1)
		address=$(echo "$dump"|grep "$ref. "|cut -d. -f2-)
	fi
	# mostra a página
	elinks -dump -dump-color-mode 3 -no-references -no-numbering "$address"
	echo -e "\033[0m"
fi

# echo "DEBUG: $address"
