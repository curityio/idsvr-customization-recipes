#!/bin/bash

###############################################################################
# Provide input customizations for the recipe to the UI builder's source volume
###############################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# The authenticate template for brand 1
#
FILE_PATH='templates/template-areas/brand1/authenticator/html-form/authenticate'
FILE_NAME='get.vm'
mkdir -p ../../ui-builder/src-vol/$FILE_PATH
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# The authenticate template for brand 2
#
FILE_PATH='templates/template-areas/brand2/authenticator/html-form/authenticate'
FILE_NAME='get.vm'
mkdir -p ../../ui-builder/src-vol/$FILE_PATH
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# English text updates for the HTML form login screen
#
FILE_PATH='messages/overrides/en/authenticator/html-form/authenticate'
FILE_NAME='messages'
mkdir -p ../../ui-builder/src-vol/$FILE_PATH
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Portuguese text updates for the HTML form login screen
#
FILE_PATH='messages/overrides/pt/authenticator/html-form/authenticate'
FILE_NAME='messages'
mkdir -p ../../ui-builder/src-vol/$FILE_PATH
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Set the UI builder URL to open, which shows the customizations
#
export UI_BUILDER_URL='http://localhost:3000/authenticator/html-form/authenticate/get?area=brand1'