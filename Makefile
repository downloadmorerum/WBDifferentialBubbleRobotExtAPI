#
# A simple Makefile that wraps the build scripts for the Swift package manager
#
BIN=DifferentialRobotCanvas

.PHONY: all build host xcode clean distclean
all: build xcode

E?=@

#! build the binary application
build:
	$E/bin/bash ./build.sh

## host is a synonym for build
host: build

#! create an xcode project
${BIN}.xcodeproj:
	$E/bin/bash ./xcodegen.sh

#! run the application
run: build
	$Eif [ -e .build/app/${BIN}.app ] ; then			\
		open .build/app/${BIN}.app ;				\
	else								\
		.build/debug/${BIN} & 					\
	fi

## default target to generate the Xcode project
xcode: ${BIN}.xcodeproj

#! clean
clean:
	rm -rf .build

#! clean everything
distclean: clean
	rm -rf Packages
