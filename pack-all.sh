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
wgtdir=$here/wgtdir

apps=$(git submodule status | sed 's: .* \(.*\) (.*:\1:')

for dir in $apps
do
	test -e $wgtdir && rm -rf $wgtdir 2>/dev/null
	appli=${dir##*/}
	wgt=${appli#webapps-}.wgt
	echo "packaging $dir to $wgt"
	cp -r $here/$dir $wgtdir
	data="$(./JSON.sh -b < $wgtdir/package.json |
		egrep "^[[]\"($pat)\"]" |
		sed 's:^[[]"\([^"]*\)"]:\1:')"
	args=
	unset $list
	for x in $list
	do
		y="$(echo "$data"|grep "^$x"|sed "s:$x	::" |
			sed 's:&:\&amp;:g;s:<:\&lt\;:g;s:>:\&gt\;:g')"
		args="$args$x=${y} "
	done
	eval "$args; echo \"${config//\"/\\\"}\"" > $wgtdir/app/config.xml
	cp $wgtdir/icon_128.png $wgtdir/app
	cd $wgtdir/app
	zip -q -r $here/$wgt .
	cd $here
	test -e $wgtdir && rm -rf $wgtdir 2>/dev/null
done

test -e $wgtdir && rm -rf $wgtdir 2>/dev/null
exit 0
