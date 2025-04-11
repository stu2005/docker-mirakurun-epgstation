#!/usr/bin/env bash

git clone -q --recursive https://github.com/stu2005/docker-mirakurun-epgstation.git ~/dtv
cd ~/dtv/

cp ./samples/*docker-compose.yaml ./
cp ./samples/epgstation/enc.js.template ./epgstation/enc.js
cp ./samples/epgstation/config.yml.template ./epgstation/config.yml
cp ./samples/epgstation/operatorLogConfig.sample.yml ./epgstation/operatorLogConfig.yml
cp ./samples/epgstation/epgUpdaterLogConfig.sample.yml ./epgstation/epgUpdaterLogConfig.yml
cp ./samples/epgstation/serviceLogConfig.sample.yml ./epgstation/serviceLogConfig.yml

docker compose -f./mirakurun.docker-compose.yaml run --rm -eSETUP=true mirakurun
docker compose -f./scan.docker-compose.yaml run --rm tvchannels-scan
docker compose -f./scan.docker-compose.yaml run --rm isdb-scanner
docker compose -f./mirakurun.docker-compose.yaml run -d --rm mirakurun
URL="http://localhost:40772/api/status"
until curl --silent --fail "$URL" > /dev/null; do
    sleep 2
done
curl -X GET "http://localhost:40772/api/channels/scan?type=GR"
curl -X GET "http://localhost:40772/api/channels/scan?type=BS"
docker compose -f./mirakurun.docker-compose.yaml down -v