#!/bin/bash

  #docker pull matchbox/$TRIGGER_REPO:latest
  
  export DATE=`TZ=America/New_York date "+%m-%d-%y-%H%M"`
  docker login -e="$DOCKER_EMAIL" -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

if [ "$TRIGGER_REPO" eq "nci-match-ir-ecosystem-api" ]; then
  docker pull matchbox/nci-match-ir-ecosystem-processor:latest
  docker tag matchbox/nci-match-ir-ecosystem-api matchbox/nci-match-ir-ecosystem-api:$DATE
  docker tag matchbox/nci-match-ir-ecosystem-processor matchbox/nci-match-ir-ecosystem-processor:$DATE
  docker images
  docker push matchbox/nci-match-ir-ecosystem-api:$DATE
  docker push matchbox/nci-match-ir-ecosystem-processor:$DATE
  # Push to UAT AWS
  docker run -it --rm -e AWS_ACCESS_KEY_ID=$UAT_AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$UAT_AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=us-east-1 silintl/ecs-deploy --cluster PedMatch-UAT-Backend --service-name PedMatch-$TRIGGER_REPO-UAT -i matchbox/$TRIGGER_REPO:$DATE
  #docker run -it --rm -e AWS_ACCESS_KEY_ID=AKIAIV2ZVB5JZ33GS3YA -e AWS_SECRET_ACCESS_KEY=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 -e AWS_DEFAULT_REGION=us-east-1 silintl/ecs-deploy --cluster PedMatch-UAT-Backend --service-name PedMatch-nci-match-ir-ecosystem-processor-UAT -i matchbox/nci-match-ir-ecosystem-processor:$DATE
else
  docker tag matchbox/$TRIGGER_REPO matchbox/$TRIGGER_REPO:$DATE
  docker images
  docker push  matchbox/$TRIGGER_REPO:$DATE
  # Push to UAT AWS
  docker run -it --rm -e AWS_ACCESS_KEY_ID=$UAT_AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$UAT_AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=us-east-1 silintl/ecs-deploy --cluster PedMatch-UAT-Backend --service-name PedMatch-$TRIGGER_REPO-UAT -i matchbox/$TRIGGER_REPO:$DATE
fi
