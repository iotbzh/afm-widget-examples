#!/bin/bash

sed -i s:switch.dl.sourceforge.net:downloads.sourceforge.net: modules/webapps-annex/bower.json
sed -i '/"main":/s:/js/main.js:/index.html:' modules/webapps-memory-match/package.json
./pack-gulp.sh annex
./pack-gulp.sh rabbit
./pack-gulp.sh memory-match
#./make-smarthome.sh

