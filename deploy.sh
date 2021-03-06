#!/bin/bash
set -e

ENVIRONMENT=$1

echo ""
echo "Building initial image"
docker build -t "66pix/s3ninja:$CIRCLE_BUILD_NUM-layered" .

echo ""
echo "Saving initial image to disk"
docker save "66pix/s3ninja:$CIRCLE_BUILD_NUM-layered" > layered.tar

echo ""
echo "Squashing image"
sudo docker-squash -i layered.tar -o squashed_latest.tar -t "66pix/s3ninja:latest"
sudo docker-squash -i layered.tar -o squashed.tar -t "66pix/s3ninja:$CIRCLE_BUILD_NUM"

echo ""
echo "Loading squashed image"
cat squashed_latest.tar | docker load
cat squashed.tar | docker load

echo ""
echo "Pushing squashed image"
docker push "66pix/s3ninja:latest"
docker push "66pix/s3ninja:$CIRCLE_BUILD_NUM"
