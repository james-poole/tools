#! /bin/bash
PS=$(docker ps -a -q)
IMAGES=$(docker images -q)
VOLUMES=$(docker volume ls -q)
NETWORKS=$(docker network ls | awk '{ if ($2!="bridge") print}' | awk '{ if ($2!="none") print}' | awk '{ if ($2!="host") print $1}' | sed 's/NETWORK//')

if [ -z "$PS" ]; then
   echo "No Docker Processes left behind."
else
   echo "Killing and removing processes. Ctrl+C to abort."
   sleep 5
   docker kill $PS && docker rm $PS
fi

if [ -z "$IMAGES" ]; then
   echo "No Images to delete."
else
   echo "Deleting all Images. Ctrl+C to abort."
   sleep 5
   docker rmi $IMAGES
fi

if [ -z "$VOLUMES" ]; then
    echo "No Docker volumes to delete."
else
    echo "Deleting all Docker volumes. Ctrl+C to abort."
    sleep 5
    docker volume rm $VOLUMES
fi

if [ -z "$NETWORKS" ]; then
    echo "No Networks to delete."
else
    echo "Deleting all Docker networks. Ctrl+C to abort."
    sleep 5
    docker network rm $NETWORKS
fi
