#!/bin/bash

# after running docker-compose up inspect created networks
docker network ls
docker inspect $network_id

# connect to a running container and inspect networking
docker exec -it $container_id sh

# inside the container check the mounted files in /etc
mount | grep /etc
cat /etc/hosts
cat /etc/resolv.conf

# connect a dns utils container to a docker network where votingapp is running
docker run -it --network $network_name tutum/dnsutils

# make dns requests to docker server with dig
dns_server=$(cat /etc/resolv.conf | head -1 | awk '{print $2}')
dig $dns_server google.com
dig $dns_server votingapp
dig $dns_server redis

