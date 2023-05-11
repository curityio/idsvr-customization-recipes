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
  SOURCE_FILE=$(basename $RELATIVE_PATH)
  SOURCE_FOLDER=${RELATIVE_PATH%"/$SOURCE_FILE"}

  # Don't copy root level files
  if [ "$SOURCE_FILE" != "$SOURCE_FOLDER" ]; then 
    
    if [ "$SOURCE_FOLDER" == 'images' ]; then
      
      # Point to the image location within the build volume
      FOLDER='webroot/assets/images'
      FILE="$SOURCE_FILE"

    elif [ "$SOURCE_FOLDER" == 'scss' ]; then
      
      # Point to the compiled CSS location within the build volume
      FOLDER='webroot/assets/css'
      FILE="${SOURCE_FILE/.scss/.css}"

    else
      
      FOLDER="$SOURCE_FOLDER"
      FILE="$SOURCE_FILE"
    fi

    ## Add to the docker compose custom resources
    echo "     - ../ui-builder/build-vol/$FOLDER/$FILE:/opt/idsvr/usr/share/$FOLDER/$FILE" >> ./custom_resources.txt
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
