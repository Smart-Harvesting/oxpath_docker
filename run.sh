#!/bin/bash

#Settings
ROOT=$(pwd)
INPUTFOLDER="$ROOT/input"
OUTPUTFOLDER="$ROOT/output"

IMAGENAME="oxpath"
TAG="latest"

CONTAINERNAME="oxpath"



echo "[+] Check if oxpath_docker is running and stop it"
docker stop oxpath || true && docker rm oxpath || true

# Creating folder structures
echo "[+] Check if the required folders are existing"
if [ ! -d "$INPUTFOLDER" ]; then
  echo "Creating $INPUTFOLDER"
  mkdir $INPUTFOLDER
fi
if [ ! -d "$OUTPUTFOLDER" ]; then
  echo "Creating $OUTPUTFOLDER"
  mkdir $OUTPUTFOLDER
fi

# if you don't want to rebuild everytime, just comment out the following lines
echo "[+] Rebuild oxpath container"
docker build -t $IMAGENAME:$TAG .
echo "[+] Delete orphan images"
docker rmi $(docker images -f "dangling=true" -q)

echo "[+] Starting the container"
docker run -d -it --name=$CONTAINERNAME \
-v $INPUTFOLDER:/usr/src/oxpath/input \
-v $OUTPUTFOLDER:/usr/src/oxpath/output \
$IMAGENAME:$TAG
