
# remove all running and stopped containers (destructive action)
docker rm -f "$(docker ps -qa)"