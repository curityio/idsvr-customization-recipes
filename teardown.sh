#!/bin/bash

###################################################################################
# Run the UI builder tool using a local volume, so that files can be edited locally
###################################################################################

#
# Stop UI builder if required
#
docker stop ui-builder 2>/dev/null

#
# Stop ngrok if required
#
if [ "$USE_NGROK" == 'true' ]; then
  kill -9 $(pgrep ngrok) 2>/dev/null
fi

#
# End the Curity Identity Server deployment
#
docker compose --project-name customization down