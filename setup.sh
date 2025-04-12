#!/usr/bin/env bash

# Get samples
git clone -q --recursive https://github.com/stu2005/docker-mirakurun-epgstation.git ~/dtv
cd ~/dtv/

# Copy compose files
cp ./samples/*docker-compose.yaml ./

# Copy scanner
mkdir ./tvchannels-scan
cp ./samples/tvchannels-scan/scanner ./tvchannels-scan/

# Set mirakurun, mirakc
mkdir ./mirakurun ./mirakc
cp ./samples/mirakurun/*sample* ./samples/mirakurun/*recpt1* ./mirakurun/
cp ./samples/mirakc/config* ./mirakc/
docker compose -f./mirakurun.docker-compose.yaml run --rm -eSETUP=true mirakurun
docker compose -f./scan.docker-compose.yaml run --rm isdb-scanner
docker compose -f./scan.docker-compose.yaml run --rm tvchannels-scan
cat ./mirakurun/channels_recpt1.yml > ./mirakurun/channels.yml
cat ./mirakurun/tuners_recpt1.yml > ./mirakurun/tuners.yml
cat ./mirakc/config_recpt1.yml > ./mirakc/config.yml
docker compose -f./mirakurun.docker-compose.yaml run -d --rm mirakurun
while [ "$(docker inspect --format='{{.State.Health.Status}}' mirakurun)" != "healthy" ]; do
    echo "Waiting for container to become healthy..."
    sleep 2
done
curl -X PUT http://localhost:40772/api/channels/scan?type=GR
curl -X PUT http://localhost:40772/api/channels/scan?type=BS
docker compose -f./mirakurun.docker-compose.yaml down -v 

# Copy epgstation configs
mkdir ./epgstation
cp ./samples/epgstation/enc.js.template ./epgstation/enc.js
cp ./samples/epgstation/config.yml.template ./epgstation/config.yml
cp ./samples/epgstation/operatorLogConfig.sample.yml ./epgstation/operatorLogConfig.yml
cp ./samples/epgstation/epgUpdaterLogConfig.sample.yml ./epgstation/epgUpdaterLogConfig.yml
cp ./samples/epgstation/serviceLogConfig.sample.yml ./epgstation/serviceLogConfig.yml

# Copy edcb configs
cp -r ./samples/edcb ./

# Copy chinachu configs
mkdir ./chinachu 
cp ./samples/chinachu/config.sample.json ./chinachu/config.json
cp ./samples/chinachu/rules.sample.json ./chinachu/rules.json