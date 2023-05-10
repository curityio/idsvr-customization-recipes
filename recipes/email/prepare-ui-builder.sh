#!/bin/bash

###############################################################################
# Provide input customizations for the recipe to the UI builder's source volume
###############################################################################

cd "$(dirname "${BASH_SOURCE[0]}")"

#
# Copy the HTML email layout
#
FILE_PATH='templates/overrides/layouts'
FILE_NAME='html-email.vm'
mkdir -p ../../ui-builder/src-vol/$FILE_PATH
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Copy the email authenticator custom messages
#
FILE_PATH='templates/authenticator/email/email'
FILE_NAME='message.vm'
mkdir -p ../../ui-builder/src-vol/$FILE_PATH
cp $FILE_PATH/$FILE_NAME ../../ui-builder/src-vol/$FILE_PATH/$FILE_NAME

#
# Set the UI builder URL to open, which shows the customizations
#
export UI_BUILDER_URL='http://localhost:3000/authenticator/email/email/message'