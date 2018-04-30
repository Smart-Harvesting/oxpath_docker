#!/bin/bash

# Paths - Absolute paths are required
INPUTFOLDER="/home/hendrik/Entwicklung/oxpath_docker/input"
OUTPUTFOLDER="/home/hendrik/Entwicklung/oxpath_docker/output"

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
docker build -t oxpath:latest .
echo "[+] Delete orphan images"
docker rmi $(docker images -f "dangling=true" -q)

echo "[+] Starting the container"
docker run -d -it --name=oxpath \
-v $INPUTFOLDER:/usr/src/oxpath/input \
-v $OUTPUTFOLDER:/usr/src/oxpath/output \
oxpath:latest
