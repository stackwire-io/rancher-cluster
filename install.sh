#!/usr/bin/env bash

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' | tee /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-engine

sudo docker run -d --restart=unless-stopped -p 8080:8080 -p 9345:9345 rancher/server:${rancher_version} \
    --db-host ${db_host} --db-port ${db_port} --db-user ${db_user} --db-pass ${db_password} --db-name rancher \
    --advertise-address `curl http://169.254.169.254/latest/meta-data/local-ipv4`
