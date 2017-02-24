import param as P
import math as math
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from PIL import Image
#matplotlib inline

pi = math.pi

 # Parameters
L_height = 10e-2                  # Height of the loop, m
L_width = 10e-2                   # Width of the loop, m
L_d = 5e-2                        # Distance of the loop's left side from the wire, m
L_R = 1                           # Internal resistance of wire, Ohms
R = 4                             # Resistance of the resistor placed across the loop's gap.
f = 1e4                           # Frequency of the current, Hz
T = 1/f                           # Period of the current signal, s
A = 5                             # Magnitude of the current signal, A
dt = 1e-7                         # Time step, s
t = np.arange(0,T,dt)             # Time array, s
I = A*np.cos(2*np.pi*f*t)         # Current through the wire, A
dy = 1e-4                         # Distance step, m
r = np.arange(L_d,L_width+L_d,dy) # An array that represents the different radii inside the loop, m
mu = 4* pi * 10e-6 # permeability of the area


print "Size of time vector: ", len(t)
# Part 1)

# Calculate the Flux through the area
# Magnetic flux going through an area is the magnetic flux density integrated over the area.
Flux  = I * np.sum(1/r) *(mu/(2*pi))*dy

# Calculate the Vemf across the small gap in the loop.
Vemf = np.zeros(len(t))
Vemf[0] = 0
for idx in range(1,len(t)):
    Vemf[idx] = -1*(Flux[idx]-Flux[idx-1])/dy # INSERT CODE HERE
print "Vemf size: ",len(Vemf)," and ", Vemf


# Part 2)
# Calculate the induced current through the 4 Ohm resistor
I_induced = Vemf/R # INSERT CODE HERE


# Plot
plt.figure(1),plt.clf

p1 = plt.plot(t,Vemf,t,I_induced)
plt.legend(p1, ['Vemf', 'Iind'])
plt.title('Vemf(t)')
plt.xlabel('time (s)')
plt.ylabel('Volts (V)')
plt.show()
