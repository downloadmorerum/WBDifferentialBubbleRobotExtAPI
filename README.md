# BubbleRobotDifferential
A client for the V-REP simulator Bubble Robot to act as a differential robot using gusimplewhiteboard.

## Robot Model
This example uses a very simple, differential robot model (defined as the purple robot in the `controlTypeExamples.ttt` VREF example scene).
It simulates a circular, two-wheeled robot with a given wheel radius
and a given half-axle length (radius of the circular robot body).

The robot keeps track of its position in the world (pixel position on the canvas), its orientation (clockwise, in radians, with zero being horizontal, pointing to the right), and the rotational velocity of its left and right wheels (in radians per second).

### Units and conversion

The TwoWheeledRobot data type adds some convenience methods and variables, to convert radians to degrees and back, and to convert rotational velocity to RPM and linear ground speed (pixels/s).

### Whiteboard

The robot uses control/status messages to interact with the whiteboard in a very simple way.  The robot instantly accelerates and does not publish its odometry on the whiteboard (this is fairly simple to add, though, and left as an exercise to the reader).

## Building
Make sure you have all the prerequisites installed (see below).  After that, you can simply clone this repository and build the command line executable (be patient, this will download all the required dependencies and take a while to compile) using

	git clone ssh://git.mipal.net/git/BubbleRobotDifferential.git
	./build.sh
	
After that, you can run the program using

	.build/debug/WBBubbleRobot

A simple, 'WBBubbleRobot' window with a robot slowly rotating around its axis should appear.  To exit the program, click the close button or press Control-C in the Terminal window.

### Xcode

On macOS, you can build the project using Xcode instead.  To do this, you need to create an Xcode project first, then open the project in the Xcode IDE:


	./xcodegen.sh
	open WBBubbleRobot.xcodeproj

After that, select the executable target (not the Bundle/Framework target with the same name as the executable) and use the (usual) Build and Run buttons to build/run your project.


## Prerequisites

### Whiteboard and gu_util

Make sure you have a current version of the Whiteboard and gu_util installed in /usr/local, e.g.:

	cd $HOME/src/MiPal/GUNao/posix/gusimplewhiteboard
	bmake host
	bmake install
	cd $HOME/src/MiPal/GUNao/posix/gu_util
	bmake host-local
	bmake install

### Swift

To build, you need Swift 3.0 (download from https://swift.org/download/ -- if you are using macOS, make sure you have the command line tools installed as well).  Test that your compiler works using `swift --version`, which should give you something like

	$ swift --version
	Apple Swift version 3.0 (swiftlang-800.0.46.2 clang-800.0.38)
	Target: x86_64-apple-macosx10.9

on macOS, or on Linux you should get something like:

	$ swift --version
	Swift version 3.0 (swift-3.0-RELEASE)
	Target: x86_64-unknown-linux-gnu


## Troubleshooting
Here are some common errors you might encounter and how to fix them.

### Old Swift toolchain or Xcode
If you get an error such as

	$ ./build.sh 
	error: unable to invoke subcommand: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-package (No such file or directory)
	
this probably means that your Swift toolchain is too old.  Make sure the latest toolchain is the one that is found when you run the Swift compiler (see above).

  If you get an older version, make sure that the right version of the swift compiler is found first in your `PATH`.  On macOS, use xcode-select to select and install the latest version, e.g.:

	sudo xcode-select -s /Applications/Xcode.app
	xcode-select --install

