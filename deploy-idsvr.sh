#!/bin/bash

############################################################
# Copy UI builder results and run the Curity Identity Server
############################################################

cd "$(dirname "${BASH_SOURCE[0]}")"
cp ./hooks/pre-commit ./.git/hooks
export CUSTOM_RESOURCES=''

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
# Basic automation to traverse recipe files and copy them from the UI builder's builder volume to the Docker container
# Comment out this section to deploy with only default files
#
rm ./files.txt            2>/dev/null
rm ./custom_resources.txt 2>/dev/null
find ./recipes/$RECIPE -type f -exec echo "{}" >> ./files.txt \;
while IFS= read -r FILE_PATH
do
  
  # Use bash support for removing prefixes and suffixes to get file names and folder paths
  RELATIVE_PATH=${FILE_PATH#"./recipes/$RECIPE/"}
  RECIPE_FILE=$(basename $RELATIVE_PATH)
  RECIPE_FOLDER=${RELATIVE_PATH%"/$RECIPE_FILE"}

  # Don't copy root level files
  if [ "$RECIPE_FILE" != "$RECIPE_FOLDER" ]; then 
    
    if [ "$RECIPE_FOLDER" == 'images' ]; then
      
      # Deploy from the source volume to the webroot subfolder
      FROM_PATH="../ui-builder/src-vol/images/$RECIPE_FILE"
      TO_PATH="webroot/assets/images/$RECIPE_FILE"

    elif [ "$RECIPE_FOLDER" == 'scss' ]; then
      
      # Deploy from the compiled CSS file in the build volume to the webroot subfolder
      CSS_FILE="${RECIPE_FILE/.scss/.css}"
      FROM_PATH="../ui-builder/build-vol/webroot/assets/css/$CSS_FILE"
      TO_PATH="webroot/assets/css/$CSS_FILE"
      

    else
      
      # Deploy from the source volume to the same relative location
      FROM_PATH="../ui-builder/src-vol/$RECIPE_FOLDER/$RECIPE_FILE"
      TO_PATH="$RECIPE_FOLDER/$RECIPE_FILE"
    fi

    ## Add to the docker compose custom resources
    echo "     - $FROM_PATH:/opt/idsvr/usr/share/$TO_PATH" >> ./custom_resources.txt
  fi

done < ./files.txt
export CUSTOM_RESOURCES=$(cat ./custom_resources.txt)
rm ./files.txt
rm ./custom_resources.txt

#
# Produce the final docker compose file, including customized resources
#
cd idsvr
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
