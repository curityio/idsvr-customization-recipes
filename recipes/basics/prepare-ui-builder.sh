#!/bin/bash

###############################################################################
# Provide input customizations for the recipe to the UI builder's source volume
###############################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Copy the settings
#
FILE_PATH='templates/overrides'
FILE_NAME='settings.vm'
mkdir -p ../../ui-builder/src-vol/$FILE_PATH
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Copy the logo image
#
FILE_PATH='images'
FILE_NAME='example-logo.png'
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Copy the custom CSS theme source, which will be compiled to a CSS file
#
FILE_PATH='scss'
FILE_NAME='example-theme.scss'
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Copy a custom message in a general properties file
#
FILE_PATH='messages/overrides/en'
FILE_NAME='custom.properties'
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Copy a custom message in the authenticate message file
#
FILE_PATH='messages/overrides/en/authenticator/html-form/authenticate'
FILE_NAME='messages'
mkdir -p ../../ui-builder/src-vol/$FILE_PATH
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Set the UI builder URL to open, which shows the customizations
#
export UI_BUILDER_URL='http://localhost:3000/authenticator/html-form/authenticate/get'