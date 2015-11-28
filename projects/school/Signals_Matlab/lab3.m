L = 3e-3;      % 3 mH
Rs = 50;        % 50 ohms
Rl = 8;         % 8 ohms
Rg = 10*Rl;     % 80 ohms
C = 4.47e-6;    % 44.7 uF

a1 = 1/(Rl*C);
a2 = 1/(L*C);
%a3 = 1/(C*(Rs+Rg));
a3 = a1;

w = logspace(1,5,1000);
freqs([a3, 0],[1, a1, a2],w);

[H, W] = freqs([a3, 0],[1, a1, a2],w);
[peak_level,indx] = max(abs(H));
peak_freq = w(indx)/(2*pi); 
peak_level_dB=20*log10(peak_level)