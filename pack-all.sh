#!/usr/bin/env bash

list="name version description main author license"
pat="${list// /|}"

config='<?xml version="1.0" encoding="UTF-8"?>
<widget xmlns="http://www.w3.org/ns/widgets" id="${appli}" version="${version}">
  <name>${name}</name>
  <icon src="icon_128.png"/>
  <content src="${main#app/}"/>
  <description>${description}</description>
  <author>${author}</author>
  <license>${license}</license>
</widget>
'

here=$(pwd)
apps=$(git submodule status | sed 's: .* \(.*\) (.*:\1:')

for dir in $apps
do
	appli=${dir##*/}
	wgt=${appli#webapps-}.wgt
	echo "packaging $dir to $wgt"
	if cd $here/$dir && npm install && bower install && grunt wgt
	then
		data="$(${here}/JSON.sh -b < package.json |
			egrep "^[[]\"($pat)\"]" |
			sed 's:^[[]"\([^"]*\)"]:\1:')"
		cd build/wgt
		args=
		unset $list
		for x in $list
		do
			y="$(echo "$data"|grep "^$x"|sed "s:$x	::" |
				sed 's:&:\&amp;:g;s:<:\&lt\;:g;s:>:\&gt\;:g')"
			args="$args$x=${y} "
		done
		echo "$data ; $args; echo \"${config//\"/\\\"}\""
		eval "$args; echo \"${config//\"/\\\"}\"" | tee config.xml
		zip -q -r $here/$wgt .
		echo "Success"
	else
		echo "Failed!"
	fi
	echo
done

exit 0
