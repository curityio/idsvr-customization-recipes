#!/bin/bash

#############################################################################################
# Copy output customizations from the UI builder's build volume to the Curity Identity Server
#############################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"
ROOT='../recipes/basics'

#
# Copy the custom message from the general properties file
#
FILE_PATH='messages/overrides/en'
FILE_NAME='custom.properties'
DOCKER_COMPOSE_LINE1="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

#
# Copy the custom message from the area specific message file
#
FILE_PATH='messages/overrides/en/authenticator/html-form/authenticate'
FILE_NAME='messages'
DOCKER_COMPOSE_LINE2="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

#
# Copy the logo fragment
#
FILE_PATH='templates/overrides/fragments'
FILE_NAME='logo.vm'
DOCKER_COMPOSE_LINE3="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

#
# Copy the logo itself
#
FILE_PATH='images'
FILE_NAME='example-logo.png'
DOCKER_COMPOSE_LINE4="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/webroot/assets/$FILE_PATH/$FILE_NAME"

#
# Export docker compose deployment lines for the above resources
#
export CUSTOM_RESOURCES=$(cat << EOF
$DOCKER_COMPOSE_LINE1
$DOCKER_COMPOSE_LINE2
$DOCKER_COMPOSE_LINE3
$DOCKER_COMPOSE_LINE4
EOF
)
