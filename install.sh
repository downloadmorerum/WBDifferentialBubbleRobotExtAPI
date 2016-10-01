#!/bin/bash
#
# Wrapper around `swift build' that uses pkg-config in config.sh
# to determine compiler and linker flags.
#
# On macOS (Darwin), this script creates an app bundle as well
#
. ./config.sh
 [ -e .build/debug/WBDifferentialBubbleRobot ] || ./build.sh
if [ `uname` = "Darwin" ]; then
    [ -e .build/app/WBDifferentialBubbleRobot.app ] || ./app-bundle.sh
    for dir in /Applications{,/Devel*}/V-REP_P*/vrep.app/Contents/MacOS /usr/local/bin ; do
	cp -p ./.build/debug/WBDifferentialBubbleRobot ${dir} || \
	sudo cp -p ./.build/debug/WBDifferentialBubbleRobot ${dir}
    done
else
    cp -p ./.build/debug/WBDifferentialBubbleRobot /usr/local/bin || \
    sudo cp -p ./.build/debug/WBDifferentialBubbleRobot /usr/local/bin
fi
