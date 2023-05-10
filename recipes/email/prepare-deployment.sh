#!/bin/bash

#############################################################################################
# Copy output customizations from the UI builder's build volume to the Curity Identity Server
#############################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"
ROOT='../ui-builder/build-vol'

#
# Copy the HTML email layout
#
FILE_PATH='templates/overrides/layouts'
FILE_NAME='html-email.vm'
DOCKER_COMPOSE_LINE1="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

#
# Copy the email authenticator custom messages
#
FILE_PATH='templates/authenticator/email/email'
FILE_NAME='message.vm'
DOCKER_COMPOSE_LINE2="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

#
# Export docker compose deployment lines for the above resources
#
export CUSTOM_RESOURCES=$(cat << EOF
$DOCKER_COMPOSE_LINE1
$DOCKER_COMPOSE_LINE2
EOF
)
