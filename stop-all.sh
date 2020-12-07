#!/bin/bash
FILES=$(ls -p ./docker-compose/users | grep -v /)
for file in $FILES
do
  echo "Stopping ./docker-compose/users/${file}"
  docker-compose -f ./docker-compose/users/${file} down
done
docker-compose -f ./docker-compose/docker-compose.wordpress.yaml down
docker-compose -f ./docker-compose/docker-compose.common.yaml down
