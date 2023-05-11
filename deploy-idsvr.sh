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
if [ "$RECIPE" != 'basics' -a "$RECIPE" != 'email' -a "$RECIPE" != 'multi-brand' ]; then
  echo 'Please provide a recipe parameter before running the deployment'
  exit 1
fi

#
# Check the build volume exists
#
if [ ! -d ./ui-builder/build-vol ]; then
  echo 'Please run the UI builder before deploying the recipe'
  exit 1
fi

#
# Prepare the recipe, by creating Docker Compose resources
#
ROOT='./ui-builder/build-vol'
rm ./idsvr/custom_resources.txt 2>/dev/null
cat ./recipes/$RECIPE/files.json | jq -c '.files[]' |
while IFS=$'\t' read -r c; do
  FOLDER=$(echo "$c" | jq -r '.folder')
  FILE=$(echo "$c" | jq -r '.file')
  echo "     - $ROOT/$FOLDER/$FILE:/opt/idsvr/usr/share/$FOLDER/$FILE" >> ./idsvr/custom_resources.txt
done
export CUSTOM_RESOURCES=$(cat ./idsvr/custom_resources.txt)

#
# Produce the final docker compose file, including customized resources
#
cd idsvr
envsubst < ./docker-compose-template.yaml > ./docker-compose.yaml
if [ $? -ne 0 ]; then
  echo '*** Problem encountered running envsubst to produce the final docker compose file'
  exit 1
fi
rm custom_resources.txt

#
# Run the deployment
#
docker compose --project-name customization down
docker compose --project-name customization up
if [ $? -ne 0 ]; then
  echo "Problem encountered running the Docker deployment"
  exit 1
fi
