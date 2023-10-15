#!/bin/bash
#
# Description: This script modifies extracted app image
#
. variables.sh



echo -n " - Injecting custom app app.ver ... "
if [[ ! "$CUSTOM_APP_APPVER" == "" ]] && ! cat ${APP_DIR}/bin/app.ver | grep -q "${CUSTOM_APP_APPVER}" ; then
	echo -e "[VER]\nappver=${CUSTOM_APP_APPVER}" > ${APP_DIR}/bin/app.ver
	echo "done"
else
	echo "already done"
fi
