# -*- coding: utf-8 -*-

# -*- coding: utf-8 -*-
import numpy as np
import matplotlib.pyplot as plt
from math import sin, pi
import sys
from scipy import signal
### FIR Filter Generation Script

# units in Hz
lowcut = 20.0        # TODO: figure out how to take a frequency and determine cutoff to rad/s
highcut = 2000.0
Fsamp = 41000.0;
nyq = 0.5 * Fsamp
low = lowcut / nyq
high = highcut / nyq
order = 9

cutoff = high

### Coefficient generation ###


#------------------------------------------------------------------------------
## --- FIR Window Method Design ---
# ----Inputs----
# numtaps (int) - length of the filter, order+1
# cutoff (float or array) - cutoff frequency of filter, same units as fs (sample freq). You can 
#                           also pass the band edges
# width (optional) - transition band width (same as fs)
# pass_zero - if true, DC Gain is 1, otherwise it is 0. This will invert your freq response
# scale - set to true to scale the coefficients fo the freq response is exactlu unity at a certain frequency
# fs - sampling frequency of the signal
#
# ----Outputs----
# h - coefficients of length numtaps
b = signal.firwin(order,[high],pass_zero=True,window='hamming')   # Hz units
a = np.ones(len(b)) # Denominator of 1 for FIR filters
w, h = signal.freqz(b,a)    # Computes the frequency response of a digital filter (w is freq and h is magnitude)
#------------------------------------------------
# Plot the FIR filter coefficients.
#------------------------------------------------
plt.figure(1)
plt.plot(b, 'bo-', linewidth=2)
plt.title('Filter Coefficients (%d taps)' % order)
plt.grid(True)

#------------------------------------------------
# Plot the magnitude response of the filter.
#------------------------------------------------

plt.figure(2)
plt.clf()
w, h = signal.freqz(b, worN=8000)
plt.plot((w/pi)*nyq, abs(h), linewidth=2)
plt.xlabel('Frequency (Hz)')
plt.ylabel('Gain')
plt.title('Frequency Response')
plt.ylim(-0.05, 1.05)
plt.grid(True)

# Upper inset plot.
#ax1 = plt.axes([0.42, 0.6, .45, .25])
#plt.plot((w/pi)*nyq, abs(h), linewidth=2)
#plt.xlim(0,8.0)
#plt.ylim(0.9985, 1.001)
#plt.grid(True)

# Lower inset plot
#ax2 = plt.axes([0.42, 0.25, .45, .25])
#plt.plot((w/pi)*nyq, abs(h), linewidth=2)
#plt.xlim(12.0, 20.0)
#plt.ylim(0.0, 0.0025)
#plt.grid(True)
#-----------------------------------------------------------------------------
### Parameters for signal.butter ###
## ----Inputs----
#
# N - filter order
# Wn - scalar or length 2 sequence that indicates the -3dB point
# btype - lowpass, highpass, bandpass, bandstop
# analog - boolean that indicates a digital or analog filter
# output - type of output: numerator/denominator "ba", pole-zero "zpk"
#
## ----Outputs---- 
#   Remember that this generates a frequency response
# b, a - Numerator (a) and denominator (b) polynomials of the IIR filter
# z,p,k - Zeros, poles and system gain of the IIR filter transfer function

## --- IIR Butterworth filter ---
#b, a = signal.butter(order, high, 'lowpass', analog=False)
#w, h = signal.freqz(b,a)    # Computes the frequency response of a digital filter (w is freq and h is magnitude)

## --- Plot the frequency response ---
#plt.plot(w, 20 * np.log10(abs(h)))
#plt.xscale('log')
#plt.title('Butterworth filter frequency response')
#plt.xlabel('Frequency [radians / second]')
#plt.ylabel('Amplitude [dB]')
#plt.margins(0, 0.1)
#plt.grid(which='both', axis='both')
#plt.axvline(cutoff, color='green') # cutoff frequency
#plt.show()

#-----------------------------------------------------------------------------

## --- Plot the filter ---
#plt.plot((Fsamp * 0.5 / np.pi) * w, abs(h), label="order = %d" % order)
#plt.plot([0, 0.5 * Fsamp], [np.sqrt(0.5), np.sqrt(0.5)], 
#             '--', label='sqrt(0.5)') # Draw dotted line at unity
#plt.xlabel('Frequency (Hz)')
#plt.ylabel('Gain')
#plt.grid(True)
#plt.legend(loc='best')
signalResolution = 48000


# Coefficients were given from a video tutorial. 
def filter(x):
    y = [0.0]*signalResolution # probs our sampling rate
    
    # --- If you have an IIR filter
    for n in range(0, len(x)):  # start from 0 since we have an FIR filter that has no prior input
        for m in range(0,len(b)):
            y[n] += b[m]*x[n-m] # the convolution itself
    return y

### Create a sinusoidal wave
frequency = 20 # units in Hz
 
### Create empty arrays
inputs = [0.0]*signalResolution
output = [0.0]*signalResolution

### Fill array with xxxHz signal
for i in range(signalResolution):
    inputs[i] = sin(2*pi*frequency*i/signalResolution) #+ sin(2*pi*70*i/48000) # add extra signals too
    
### run the signal through the filter 
output = filter(inputs) # understand this function... a convolution!

### Grab samples from input and output #1/10th of a second (sampling 48ksamples/second)
output_section = output[0:signalResolution]
input_section = inputs[0:signalResolution]

### Plot the signals for comparison
plt.figure(3)
plt.subplot(211)
plt.ylabel('Magnitude')
plt.xlabel('Samples')
plt.title('Unfiltered Signal')
plt.plot(input_section)
plt.subplot(212)
plt.ylabel('Magnitude')
plt.xlabel('Samples')
plt.title('Unfiltered Signal')
plt.plot(output_section)
plt.show()
