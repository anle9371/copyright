#!/bin/bash

# commit the container to an image for later inspection

# build the image
docker build -t image_recognition .

# run the container in detached mode
docker run -d --privileged -v ~/tf_files:/tf_files --name mycontainer image_recognition

# grab container id
CID="$(docker inspect --format="{{.Id}}" mycontainer)"

# print
echo "${CID}"

# Use signals to communicate with an application from the host machine
# check if the model is done being compiled and retrained

# commit
docker commit "${CID}" amyle/computer-vision:flowers
