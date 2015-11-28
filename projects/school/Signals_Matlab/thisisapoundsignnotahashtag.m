R1 = 1000;
C = 4.47e-6;
L = 3e-3;
Rl = 8;
Rg = 80;
Rs = 50;
A1 = 1 / (Rl * C);
A2 = 1 / (L*C);
A3 = 1/ (C * (Rs + Rg));
C2 = 1/(R1*A1)
R2 = (A1 -sqrt((A1)^2 - 4*R1*A1*A2*C2))/(2*A2*C2)
C1 = 1/(R1 * R2 * A2 * C2)

w = logspace(1,5,1000);
freqs([A1, 0],[1, A1, A2],w);

[H, W] = freqs([A3, 0],[1, A1, A2],w);
[peak_level,indx] = max(abs(H));
peak_freq = w(indx)/(2*pi); 
peak_level_dB=20*log10(peak_level)

