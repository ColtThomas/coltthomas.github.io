# cmthomas000.github.io

/********************************
    Laser Tag - Junior Project
********************************/

Our goal for this project was to create a portable laser tag system 
using the ZYBO board, an embedded software development platform.  We 
designed the hardware for the transmitter and receiver boards, and 
used modified NERF guns.  The boards were able to 'shoot' and receive
'hits' via photodiodes and LEDs mounted in the NERF gun. 

// - DSP techniques

We sampled the voltage across our photodiode using cascaded BJT amplifiers (the receiver board).  This connected to our A/D converter.
The signal was filtered through an FIR filter which acted as our lowpass filter, and we used 10 sets of IIR filters that we used to 
pass our samples though.  Each filter was centered at one of the 10 
player frequencies.  This allowed us to continuously compute the 
power of the output of each filter.  The IIR filter outputing the
highest power indicated a hit from the respective player.
