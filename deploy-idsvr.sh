#!/bin/bash

############################################################
# Copy UI builder results and run the Curity Identity Server
############################################################

cd "$(dirname "${BASH_SOURCE[0]}")"
cp ./hooks/pre-commit ./.git/hooks

#
# Check for a license file
#
if [ ! -f './idsvr/license.json' ]; then
  echo "Please provide a license.json file in the idsvr folder in order to deploy the system"
  exit 1
fi

#
# Check a recipe has been provided
#
if [ "$RECIPE" != 'basics' -a "$RECIPE" != 'email' -a "$RECIPE" != 'template-areas' ]; then
  echo 'Please provide a recipe parameter before running the deployment'
  exit 1
fi

#
# Prepare the recipe, to set file copy paths to apply to docker compose
# This dot sources a script and sets the CUSTOM_RESOURCES environment variable
#
. ./recipes/$RECIPE/prepare-deployment.sh
cd ../../idsvr

#
# Produce the final docker compose file, including customized resources
#
envsubst < ./docker-compose-template.yaml > ./docker-compose.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered running envsubst to produce the final docker compose file'
  exit 1
fi

#
# Run the deployment
#
docker compose --project-name customization down
docker compose --project-name customization up
if [ $? -ne 0 ]; then
  echo "Problem encountered running the Docker deployment"
  exit 1
fi
