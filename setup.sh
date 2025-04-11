#!/usr/bin/env bash

git clone -q --recursive https://github.com/stu2005/docker-mirakurun-epgstation.git ~/dtv
cd ~/dtv/

cp ./samples/*docker-compose.yaml ./
cp ./samples/epgstation/enc.js.template ./epgstation/enc.js
cp ./samples/epgstation/config.yml.template ./epgstation/config.yml
cp ./samples/epgstation/operatorLogConfig.sample.yml ./epgstation/operatorLogConfig.yml
cp ./samples/epgstation/epgUpdaterLogConfig.sample.yml ./epgstation/epgUpdaterLogConfig.yml
cp ./samples/epgstation/serviceLogConfig.sample.yml ./epgstation/serviceLogConfig.yml