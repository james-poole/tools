#! /bin/bash
PS=$(docker ps -a -q)
IMAGES=$(docker images -q)
VOLUMES=$(docker volume ls -q)
NETWORKS=$(docker network ls | awk '{ if ($2!="bridge") print}' | awk '{ if ($2!="none") print}' | awk '{ if ($2!="host") print $1}' | sed 's/NETWORK//')
echo "Welcome to James' docker cleanup script"
if [ -z "$PS" ]; then
   echo -e "\e[32mNo Processes left behind.\e[0m"
else
   echo -e "\e[31mProcesses found. Kill and delete?"
   read -r -p "[y/N]" response
   response=${response,,}
   if [[ $response =~ ^(yes|y)$ ]]; then
        echo -e "Killing and removing processes in 5 seconds. Ctrl+C to abort.\e[0m"
        sleep 5
        echo -e "Deleting processes..."
        docker kill $PS &>/dev/null
        docker rm $PS &>/dev/null
        echo -e "Done"
   else
        echo -e "Ok moving on."
   fi
fi

if [ -z "$IMAGES" ]; then
   echo -e "\e[32mNo Images to delete.\e[0m"
else
   echo -e "\e[31mImages found. Delete all?"
   read -r -p "[y/N]" response
   response=${response,,}
   if [[ $response =~ ^(yes|y)$ ]]; then
        echo -e "Deleting all local docker images in 5 seconds. Ctrl+C to abort.\e[0m"
        sleep 5
        echo -e "Deleting images..."
        docker rmi -f $IMAGES &>/dev/null
        echo -e "Done"
   else
        echo -e "Ok moving on."
   fi
fi

if [ -z "$VOLUMES" ]; then
    echo -e "\e[32mNo Volumes to delete.\e[0m"
else
    echo -e "\e[31mVolumes found. Delete?"
    read -r -p "[y/N]" response
    response=${response,,}
    if [[ $response =~ ^(yes|y)$ ]]; then
        echo -e "Deleting all local docker volumes in 5 seconds. Ctrl+C to abort.\e[0m"
        sleep 5
        echo -e "Deleting volumes..."
        docker volume rm $VOLUMES &>/dev/null
        echo -e "Done"
    else
        echo -e "Ok moving on."
    fi
fi

if [ -z "$NETWORKS" ]; then
    echo -e "\e[32mNo Networks to delete.\e[0m"
else
    echo -e "\e[31mNetworks found. Delete all?"
    read -r -p "[y/N]" response
    response=${response,,}
    if [[ $response =~ ^(yes|y)$ ]]; then
        echo -e "Deleting all local docker networks in 5 seconds. Ctrl+C to abort.\e[0m"
        sleep 5
        echo -e "Deleting networks..."
        docker network rm $NETWORKS &>/dev/null
        echo -e "Done."
    fi
fi
echo -e "All done."
