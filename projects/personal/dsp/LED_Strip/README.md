# LED Strip Oscillator

**Description:** Adds a lightshow to your beats. Input your favorite beats as audio to the system to get LEDs that oscillate with the bass

**Status:** Incomplete. 
- A verilog module was created to receive the individual samples, and a Verilog testbench file was created. Verilog requires a live test on the FPGA with the ADC. (Complete)
- A python script was created to generate FIR coefficients, and successfully filters simple sinusoidal signals.
- Nexys 2 board connected to the ADC. No samples were received; Microphones for audio input may be inoperable, or the output voltage from the FPGA insufficient. The clock may also be too fast @50MHz
- Found out how to program the ICEstick with a basic led hello world; will try to interface with ADC

**In Progress:**
- Verilog sample receiver module - Runs fine with virtual simulation; will verify implementation on FPGA

**TODO:**
- Clock correction (Max input freq: 3.6 MHz for 5 Vref, 1.35 MHz for 2.7 Vref,2.3MHz for 3.3Vref)
- Create ICEstick ADC connection verification module; LED indicative for positive serial connection
- Test PMOD Vdd/Ground pins to see if they are automatically enabled
- Create buffer to store samples
- Create a high level controller to initiate DSP operations and manage incoming samples
- Basic FIR filter for noise 
- LED volume meter (for testing)
- System level design for LED strip oscillation

**Equipment:**
- Adafruit MCP3008
- Xilinx Nexys2 Development Board

## Notes for the 3008 ADC
- Vdd: Power supply. set to 5V (3.3V also acceptable)
- Vref: Max imput voltage to ADC. Set to 5V for audio (3.3V also acceptable)
- Fsample: 200 ksps
- Fclock: 18*Fsample

### Sample Frequency
- Target sample frequency is 96kHz
- 96KHz * 18 = 1.728MHz required clk
- Nexys board clk divider math: 50MHz/1.728MHz = 28.93 => 29
- ICEStick clk divider math: 

## Notes for the Nexys 2 board
- It looks like the PMOD connectors have the ground and Vdd constantly enabled. Check to see what each pin is configured as.

**Wire Connections**
Rough text-based block diagram:

MCP3008          Nexys2 PMOD  
Vdd -----------> (pin 6)  
Vref ----------> (pin 6)  
AGND ----------> (pin 5)  
CLK  ----------> JA1(pin 1)  
Dout ----------> JA2(pin 2)  
Din -----------> JA3(pin 3)  
CS ------------> JA4(pin 4, may need to invert signal? See MCP data sheet)  
DGND ----------> (pin 5)  

## Notes for ICEstick
- Try to run code on an ICEstick in tandem with the Nexys; I had a random issue where the Nexys wouldn't place and route in ISE
- Need to find/create a PCF file, which is equivalent to a .ucf file (complete)
- See this [tutorial](https://www.youtube.com/watch?v=1CNVsxoLI60) on how to get an ICEstick to run your firmware

### Procedures for Running Firmware
For now, just take the following on blind faith:

`yosys -p  "synth_ice40 -blif demo.blif" demo.v`  
`arachne-pnr -d 1k -p icestick.pcf demo.blif -o demo.txt`  
`icepack demo.txt demo.bin`  
`iceprog demo.bin`  

## Toolchain notes
The executable for ModelSim can be found in: '~/ModelSim/modelsim_ase/linuxaloem/vsim'. I followed the instructions for method
one at [this](https://mattaw.blogspot.com/2014/05/making-modelsim-altera-starter-edition.html) link. ModelSim is a bit easier to 
use since Xilinx ISE requires .tcl files to simulate vs. using a Verilog/SystemVerilog testbench.

## Sampling 
-Each sample produces a 10 bit serial code (2^10 = 1024). This gives us a precision of Vref/1024 meaining that for every one bit, we get the 
calculated quantity of voltage. E.G. for 5Vref, 1 bit represents 0.00488V. A smaller Vref gives higher precision, but a lower Vmax for a 
sampled signal.

## Filtering

**Useful Links:**
- [Simplified FIR Filter Structure](https://www.embedded.com/design/real-time-and-performance/4008837/DSP-Tricks-An-odd-way-to-build-a-simplified-FIR-filter-structure)
- [ADC Datasheet - MCP3008](https://cdn-shop.adafruit.com/datasheets/MCP3008.pdf)
