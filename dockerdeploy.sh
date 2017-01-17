#!/bin/bash
echo TRIGGER_REPO $TRIGGER_REPO
echo TRIGGER_VER $TRIGGER_VER
echo CUC_TAG $CUC_TAG
docker pull matchbox/$TRIGGER_REPO:TRIGGER_VER
  
if [ "$TRIGGER_REPO" == "nci-match-ir-ecosystem-api" ]; then
  echo "Deploying to AWS UAT"
  docker run -it --rm -e AWS_ACCESS_KEY_ID=$UAT_AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$UAT_AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=us-east-1 silintl/ecs-deploy --cluster PedMatch-UAT-Backend --service-name PedMatch-nci-match-ir-ecosystem-api-UAT -i matchbox/nci-match-ir-ecosystem-api:$TRIGGER_VER
  docker run -it --rm -e AWS_ACCESS_KEY_ID=$UAT_AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$UAT_AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=us-east-1 silintl/ecs-deploy --cluster PedMatch-UAT-Backend --service-name PedMatch-nci-match-ir-ecosystem-processor-UAT -i matchbox/nci-match-ir-ecosystem-processor:$TRIGGER_VER
else
  echo "Deploying to AWS UAT"
  docker run -it --rm -e AWS_ACCESS_KEY_ID=$UAT_AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$UAT_AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=us-east-1 silintl/ecs-deploy --cluster PedMatch-UAT-Backend --service-name PedMatch-$TRIGGER_REPO-UAT -i matchbox/$TRIGGER_REPO:$TRIGGER_VER
fi
