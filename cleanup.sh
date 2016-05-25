#! /bin/bash
PS=$(docker ps -a -q)
IMAGES=$(docker images -q)
VOLUMES=$(docker volume ls -q)
NETWORKS=$(docker network ls | awk '{ if ($2!="bridge") print}' | awk '{ if ($2!="none") print}' | awk '{ if ($2!="host") print $1}' | sed 's/NETWORK//')

if [ -z "$PS" ]; then
   echo "No Docker Processes left behind."
else
   echo "Targets acquired. Kill and delete?"
   read -r -p "[y/N]" response
   response=${response,,}
   if [[ $response =~ ^(yes|y)$ ]]; then   
        echo "Killing and removing processes. Ctrl+C to abort."
        sleep 5
        docker kill $PS
        docker rm $PS
   else
        echo "Ok moving on."
   fi
fi

if [ -z "$IMAGES" ]; then
   echo "No Images to delete."
else
   echo "Targets acquired. Kill and delete?"
   read -r -p "[y/N]" response
   response=${response,,}  
   if [[ $response =~ ^(yes|y)$ ]]; then
        echo "Deleting all local images. Ctrl+C to abort."
        sleep 5
        docker rmi $IMAGES
   else
        echo "Ok moving on."
   fi
fi

if [ -z "$VOLUMES" ]; then
    echo "No Docker volumes to delete."
else
    echo "Targets acquired. Kill and delete?"
    read -r -p "[y/N]" response
    response=${response,,}    
    if [[ $response =~ ^(yes|y)$ ]]; then
        echo "Deleting all local docker volumes. Ctrl+C to abort."
        sleep 5
        docker volume rm $VOLUMES
    else
        echo "Ok moving on."
    fi
fi

if [ -z "$NETWORKS" ]; then
    echo "No Networks to delete."
else
    echo "Targets acquired. Kill and delete?"
    read -r -p "[y/N]" response
    response=${response,,}
    if [[ $response =~ ^(yes|y)$ ]]; then
        echo "Deleting all local docker networks. Ctrl+C to abort."
        sleep 5
        docker network rm $NETWORKS
    else
        echo "Ok moving on."
    fi
fi
