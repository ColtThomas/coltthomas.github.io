# ICEStick Specific Examples
This folder is for templates and examples of the ICEstick FPGA. Details to be added

## How to Run "Hello World" compilation
In a linux terminal you run the following commands:

'yosys -p  "synth_ice40 -blif top.blif" top.v'

'arachne-pnr -d 1k -p icestick.pcf demo.blif -o top.txt'

'icepack top.txt top.bin'

'iceprog top.bin'

Of course, make sure that you install yosys, arachne-pnr, icepack, etc. Check out the [icestorm project](http://www.clifford.at/icestorm/) if you need additional details on the open source toolchains. The string "top" (e.g. top.v) can be replaced with whatever you have.
