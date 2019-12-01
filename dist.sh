#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
DATE="$( date '+%Y%m%d%H%S' )"
DIST_DIR=$SCRIPTPATH/dist
DIST_FILE=wiisdl-$DATE.tar.gz

#
# Function that is invoked when the script fails.
#
# $1 - The message to display prior to exiting.
#
function fail() {
    echo $1
    echo "Exiting."
    exit 1
}

# Change to script directory
echo "Changing to script directory..."
cd $SCRIPTPATH || { fail 'Error changing to script directory.'; }

# Build Wii7800
echo "Building SDL..."
make || { fail 'Error building SDL.'; }

# Clear dist directory
if [ -d $DIST_DIR ]; then
    echo "Clearing dist directory..."
    rm -rf $DIST_DIR || { fail 'Error clearing dist directory.'; }
fi

# Create dist directory
echo "Creating dist directory..."
mkdir -p $DIST_DIR || { fail 'Error creating dist directory.'; }

# Copying libraries
echo "Copying libraries..."
find . -type d -name "lib" \
    -exec mkdir -p ./dist/{} \; -exec cp -r {}/ ./dist/{}/.. \; \
    || { fail 'Error copying libraries.'; }

# Copying libraries
echo "Copying headers..."
find . -type d -name "include" \
    -exec mkdir -p ./dist/{} \; -exec cp -r {}/ ./dist/{}/.. \; \
    || { fail 'Error copying headers.'; }

# Create the distribution (tar.gz)    
echo "Creating distribution..."
cd $DIST_DIR || { fail 'Error changing to dist directory.'; }
tar cvzf $DIST_FILE * || { fail 'Error creating distribution.'; }
find $DIST_DIR ! -path $DIST_DIR -type d -exec rm -rf {} + \
    || { fail 'Error removing intermediate files.'; }

