#!/bin/bash
#
# Wrapper around `swift build' that uses pkg-config in config.sh
# to determine compiler and linker flags.
#
# On macOS (Darwin), this script creates an app bundle as well
#
. ./config.sh
swift build $CCFLAGS $LINKFLAGS "$@"
if [ `uname` = "Darwin" ]; then
	. ./app-bundle.sh
fi
