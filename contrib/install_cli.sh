 #!/usr/bin/env bash

 # Execute this file to install the cl cli tools into your path on OS X

 CURRENT_LOC="$( cd "$(dirname "$0")" ; pwd -P )"
 LOCATION=${CURRENT_LOC%Cl-Qt.app*}

 # Ensure that the directory to symlink to exists
 sudo mkdir -p /usr/local/bin

 # Create symlinks to the cli tools
 sudo ln -s ${LOCATION}/Cl-Qt.app/Contents/MacOS/cld /usr/local/bin/cld
 sudo ln -s ${LOCATION}/Cl-Qt.app/Contents/MacOS/cl-cli /usr/local/bin/cl-cli
