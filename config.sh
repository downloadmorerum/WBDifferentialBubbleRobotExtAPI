#!/bin/bash
#
ver=1.0
Mod=WBDifferentialBubbleRobot
Module=${Mod}-$ver
mod=`echo "${Mod}" | tr '[:upper:]' '[:lower:]'`+
module="${mod}-${ver}"
EXECUTABLE_NAME=${Mod}
PRODUCT_NAME=${Mod}
FULL_PRODUCT_NAME=${Mod}.app
PRODUCT_BUNDLE_IDENTIFIER=${ID}.${Mod}
MACOSX_DEPLOYMENT_TARGET=10.11
RESOURCES_DIR=`pwd`/Resources
BUILD_DIR=`pwd`/.build
BUILD_BIN=${BUILD_DIR}/debug
BUILT_PRODUCTS_DIR=${BUILD_DIR}/app
LINKFLAGS="-Xlinker -L/usr/local/lib"
CCFLAGS="-Xcc -I/usr/local/include -Xcc -I/usr/local/include/ExtAPI"
TAC="tail -r"
if which tac >/dev/null ; then
   TAC=tac
   else if which gtac >/dev/null ; then
	TAC=gtac
   fi
fi
