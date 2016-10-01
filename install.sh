#!/bin/bash
#
# Install the binary.
#
# On macOS, this script installs the app bundle in /Applications as well
#
. ./config.sh
 [ -e .build/debug/${Mod} ] || ./build.sh
if [ `uname` = "Darwin" ]; then
    [ -e .build/app/${Mod}.app ] || ./app-bundle.sh
    for dir in /Applications{,/Devel*}/V-REP_P*/vrep.app/Contents/MacOS /usr/local/bin ; do
	[ ! -e ${dir} ] ||						\
	( ( cp -p ./.build/debug/${Mod} ${dir} ||			\
	sudo cp -p ./.build/debug/${Mod} ${dir} ) &&			\
	echo "Installed in ${dir}/${Mod}" |				\
	sed -e 's|/\([^/.]*.app\)|:	:\1.app|' -e 's/$/	/' |	\
	tr '\t' '\n' | sed 's/^:/		/' )
    done
    cp -pR .build/app/${Mod}.app /Applications ||			\
    sudo cp -pR .build/app/${Mod}.app /Applications
    echo "Installed in /Applications: ${Mod}.app"
else
    mkdir -p /usr/local/bin || sudo mkdir -b /usr/local/bin
    cp -p ./.build/debug/${Mod} /usr/local/bin ||			\
    sudo cp -p ./.build/debug/${Mod} /usr/local/bin
    echo "Installed in ${dir}: ${Mod}"
fi
