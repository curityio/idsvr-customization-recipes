#!/bin/bash

###################################################################################
# Run the UI builder tool using a local volume, so that files can be edited locally
###################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Check a recipe has been provided
#
if [ "$RECIPE" != 'basics' -a "$RECIPE" != 'email' -a "$RECIPE" != 'multi-brand' ]; then
  echo 'Please provide a valid RECIPE parameter before running the deployment'
  exit 1
fi

#
# Create the ui-builder folder
#
rm -rf ui-builder 2>/dev/null
mkdir ui-builder

#
# Run the UI builder the first time to copy files locally
#
echo 'Copying UI builder files from the docker image ...'
docker rm --force ui-builder 2>/dev/null
docker run --name ui-builder -d curity.azurecr.io/curity/ui-builder:8.1.0
docker cp ui-builder:/opt/ui-builder/src/curity ./ui-builder/src-vol
docker rm --force ui-builder
echo 'Files to customize have been copied locally at ./ui-builder/src-vol'

#
# Basic automation to traverse recipe files and copy them to the UI builder's source volume
# Comment out this section to run UI builder without any customization
#
rm ./files.txt 2>/dev/null
find ./recipes/$RECIPE -type f -exec echo "{}" >> ./files.txt \;
while IFS= read -r FILE_PATH
do
  
  # Use bash support for removing prefixes and suffixes to get file names and folder paths
  RELATIVE_PATH=${FILE_PATH#"./recipes/$RECIPE/"}
  RECIPE_FILE=$(basename $RELATIVE_PATH)
  RECIPE_FOLDER=${RELATIVE_PATH%"/$RECIPE_FILE"}
  
  # Ignore root level files
  if [ "$RECIPE_FILE" != "$RECIPE_FOLDER" ]; then 
    
    # Copy to the UI builder's source volume
    mkdir -p "./ui-builder/src-vol/$RECIPE_FOLDER"
    cp "./recipes/$RECIPE/$RECIPE_FOLDER/$RECIPE_FILE" "./ui-builder/src-vol/$RECIPE_FOLDER/$RECIPE_FILE"
  fi
done < ./files.txt

#
# Then run the Docker image pointing to the source and build volumes
# The input files are built from the source volume to the build volume
#
echo 'Running the UI builder docker image ...'
docker run --name ui-builder -p 3000:3000 -p 3001:3001 -p 4060:4060 \
       -v $(pwd)/ui-builder/src-vol:/opt/ui-builder/src/curity \
       -v $(pwd)/ui-builder/build-vol:/opt/ui-builder/build/curity \
       -d curity.azurecr.io/curity/ui-builder:8.1.0

#
# Wait for it to come up
#
echo 'Waiting for the UI builder to come up ...'
while [ "$(curl -s -m 1 -o /dev/null -w ''%{http_code}'' http://localhost:3000/listing)" != '200' ]; do
  sleep 2
done

case "$(uname -s)" in
  Darwin)
    PLATFORM="MACOS"
 	;;

  MINGW64*)
    PLATFORM="WINDOWS"
	;;

  Linux)
    PLATFORM="LINUX"
	;;
esac

#
# Open the browser
#
UI_BUILDER_URL=$(cat ./recipes/$RECIPE/ui-builder-url.txt)
if [ "$PLATFORM" == 'MACOS' ]; then
  open "$UI_BUILDER_URL"
elif [ "$PLATFORM" == 'WINDOWS' ]; then
  start "$UI_BUILDER_URL"
elif [ "$PLATFORM" == 'LINUX' ]; then
  xdg-open "$UI_BUILDER_URL"
fi
