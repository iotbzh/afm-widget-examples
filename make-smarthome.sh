#!/usr/bin/env bash

here=$(pwd)

mkdir $here/tmp

curl -s https://share.basyskom.com/demos/smarthome_src.tar.gz |
tar -f - --transform='s:^smarthome_src:tmp:' -z -x

cd $here/tmp

cat << EOC > config.xml
<?xml version="1.0" encoding="UTF-8"?>
<widget xmlns="http://www.w3.org/ns/widgets" id="smarthome" version="0.1">
  <name>SmartHome</name>
  <icon src="smarthome.png"/>
  <content src="qml/smarthome/smarthome.qml" type="text/vnd.qt.qml"/>
  <description>This is the Smarthome QML demo application. It shows some user interfaces for controlling an 
automated house. The user interface is completely done with QML.</description>
  <author>Qt team</author>
  <license>GPL</license>
</widget>
EOC

cp smarthome.png icon_128.png
zip -q -r $here/smarthome.wgt .

cd $here

rm -rf $here/tmp

