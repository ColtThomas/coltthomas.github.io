# LED Strip Oscillator

Description: Adds a lightshow to your beats. Input your favorite beats as audio to the system to get LEDs that oscillate with the bass

Equipment:
-Adafruit MCP3008
-Xilinx Nexys2 Development Board

## Notes for the 3008 ADC
-Vdd: Power supply. set to 5V
-Vref: Max imput voltage to ADC. Set to 5V for audio
-Fsample: 200 ksps
-Fclock: 18*Fsample

## Sampling 
-Each sample produces a 10 bit serial code (2^10 = 1024). This gives us a precision of Vref/1024 meaining that for every one bit, we get the 
calculated quantity of voltage. E.G. for 5Vref, 1 bit represents 0.00488V. A smaller Vref gives higher precision, but a lower Vmax for a 
sampled signal.
