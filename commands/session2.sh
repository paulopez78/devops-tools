#!/bin/bash

# make sure docker is installed correctly
docker version

# list images
docker images
docker image ls

# pull and run a container
# nginx
docker pull nginx
docker run -p 8080:80 nginx

# rabbitmq
docker pull rabbitmq:management
docker run -p 15672:15672 rabbitmq:management

# list running containers
docker ps

# list running and stoped containers
docker ps -a

# stop and start containers
container_id=xxxx
docker stop $container_id
docker start $container_id
docker logs $container_id -f

# rm containers
docker rm -f $container_id

# remove all running and stopped containers (very destructive action)
docker rm -f "$(docker ps -qa)"

# run ubuntu interactive container
docker run -it ubuntu
# check hostname/ip/pid/disk
hostname -i
ps -aux
df -h

# check image layers with history and inspect
docker history ubuntu
docker inspect ubuntu | jq '.[0].RootFS.Layers'

#commit changes (curl installation) and check images list
docker commit $container_id kurl
docker images | grep -E 'ubuntu|kurl'

# compare history with ubuntu image
docker history kurl
docker inspect kurl | jq '.[0].RootFS.Layers'

# more automated way
docker rm -f kurl-container && \
docker run \
    --name kurl-container \
    ubuntu sh -c "apt-get update && apt-get install curl -y && rm -rf /var/lib/apt/lists/*" \
&& docker commit kurl-container kurl-image \
&& docker image ls kurl-image