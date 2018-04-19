#!/usr/bin/env bash

list="name version description main author license"
pat="${list// /|}"

config='<?xml version="1.0" encoding="UTF-8"?>
<widget xmlns="http://www.w3.org/ns/widgets" id="${appli}" version="${version}">
  <name>${name}</name>
  <icon src="icon_128.png"/>
  <content src="${main#app/}" type="text/html"/>
  <description>${description}</description>
  <author>${author}</author>
  <license>${license}</license>
  <feature name="urn:AGL:widget:required-permission">
    <param name="urn:AGL:permission::public:no-htdocs" value="required" />
  </feature>
  <feature name="urn:AGL:widget:required-api">
    <param name="windowmanager" value="ws" />
    <param name="homescreen" value="ws" />
  </feature>
</widget>
'

here=$(pwd)

for widget
do
	dir=modules/webapps-$widget
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
