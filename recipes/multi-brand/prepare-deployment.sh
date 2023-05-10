#!/bin/bash

#############################################################################################
# Copy output customizations from the UI builder's build volume to the Curity Identity Server
#############################################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"
ROOT='../ui-builder/build-vol'

#
# The authenticate template for brand 1
#
FILE_PATH='templates/template-areas/brand1/authenticator/html-form/authenticate'
FILE_NAME='get.vm'
DOCKER_COMPOSE_LINE1="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

#
# The authenticate template for brand 2
#
FILE_PATH='templates/template-areas/brand2/authenticator/html-form/authenticate'
FILE_NAME='get.vm'
DOCKER_COMPOSE_LINE2="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

#
# English text updates for the HTML form login screen
#
FILE_PATH='messages/overrides/en/authenticator/html-form/authenticate'
FILE_NAME='messages'
DOCKER_COMPOSE_LINE3="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

#
# Portuguese text updates for the HTML form login screen
#
FILE_PATH='messages/overrides/pt/authenticator/html-form/authenticate'
FILE_NAME='messages'
DOCKER_COMPOSE_LINE4="     - $ROOT/$FILE_PATH/$FILE_NAME:/opt/idsvr/usr/share/$FILE_PATH/$FILE_NAME"

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
