#!/bin/env sh

container_name=composer-temp
if [[ $(docker ps -a | grep $container_name) ]]; then
    docker rm -f $container_name > /dev/null
fi
docker run --name=$container_name -v $(pwd):/app:rw mkenney/composer composer $1
docker rm -f $container_name > /dev/null

