#!/bin/bash

#Step 1 : download latest from ovh's FTP using same version as the current one
wget -N ftp://ftp.ovh.net/made-in-ovh/bzImage/latest-production/bzImage-$CURRENT_VERSION > /dev/null 2>&1
RES=$?
if [[ ! $RES = "0" ]];then 
        #If the current running kernel version is not the latest one, we can stop now
        echo $CURRENT_VERSION is not the latest from OVH
        exit $RES
fi

#Step 2 : Check the build id  #NNNN from the current running kernel and the downloaded one
LATEST_SHARP=`file bzImage-$CURRENT_VERSION  | sed -r -s "s/.+([#][[:digit:]]+)[[:space:]].+/\1/g"`
CURRENT_SHARP=`uname -a | sed -r -s "s/.+([#][[:digit:]]+)[[:space:]].+/\1/g"` 
if [[ ! "$CURRENT_SHARP" = "$LATEST_SHARP" ]]; then
        #If both build ids do not match, return an error
        echo Build $CURRENT_SHARP is not the the same as the one from OVH $LATEST_SHARP
        exit 1
fi
#Current kernel is the latest one and the build is the same, we can exit with success
echo 0
exit 0
