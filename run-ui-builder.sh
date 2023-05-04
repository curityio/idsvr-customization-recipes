#!/bin/bash

###################################################################################
# Run the UI builder tool using a local volume, so that files can be edited locally
###################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Create the folder
#
rm -rf ui-builder 2>/dev/null
mkdir ui-builder
cd ui-builder

#
# Check a recipe has been provided
#
if [ "$RECIPE" != 'basics' -a "$RECIPE" != 'template-areas' ]; then
  echo 'Please provide a valid RECIPE parameter before running the deployment'
  exit 1
fi

#
# Run the UI builder the first time to copy files locally
#
echo 'Copying UI builder files from the docker image ...'
docker rm --force ui-builder 2>/dev/null
docker run --name ui-builder -d curity.azurecr.io/curity/ui-builder:8.1.0
docker cp ui-builder:/opt/ui-builder/src/curity src-vol
docker rm --force ui-builder
echo 'Files to customize have been copied locally at ./ui-builder/src-vol'

#
# Prepare the recipe, to copy customizations to the source volume
# This also dot sources a script to set the UI_BUILDER_URL environment variable
#
. ../recipes/$RECIPE/prepare-ui-builder.sh
cd ../../ui-builder

#
# Then run the Docker image pointing to the local copy of files
#
echo 'Running the UI builder docker image ...'
docker run --name ui-builder -p 3000:3000 -p 3001:3001 \
       -v $(pwd)/src-vol:/opt/ui-builder/src/curity \
       -d curity.azurecr.io/curity/ui-builder:8.1.0

#
# Wait for it to come up
#
echo 'Waiting for the UI builder to come up ...'
while [ "$(curl -s -m 1 -o /dev/null -w ''%{http_code}'' "$UI_BUILDER_URL")" != '200' ]; do
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
if [ "$PLATFORM" == 'MACOS' ]; then
  open "$UI_BUILDER_URL"
elif [ "$PLATFORM" == 'WINDOWS' ]; then
  start "$UI_BUILDER_URL"
elif [ "$PLATFORM" == 'LINUX' ]; then
  xdg-open "$UI_BUILDER_URL"
fi
