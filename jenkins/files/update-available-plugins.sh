#!/bin/sh

cd /tmp

wget -O default.js http://updates.jenkins-ci.org/update-center.json
sed '1d;$d' default.js > default.json
curl --retry 10 --retry-delay 5 -X POST -H "Accept: application/json" -d @default.json http://localhost:8080/updateCenter/byId/default/postBack
rm default.json

logger "Jenkins plugins listing - updated"
