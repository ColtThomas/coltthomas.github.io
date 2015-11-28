B = [0, 0, 0, 0, 1.16238e17]; 
A = [1, 49257.78, 1.21309e9, 1.7501e13,1.26238e17]; 
%zplane(B,A);


a1 = 49257.7;
a2 = 1.21309e9;
a3 = 1.7501e13;
a4 = 1.26238e17;

w = logspace(1,5,1000);
freqs([0, 0, 0, a4],[1, a1, a2, a3, a4],w);

[H, W] = freqs([0, 0, 0, a4],[1, a1, a2, a3, a4],w);
[peak_level,indx] = max(abs(H));
peak_freq = w(indx)/(2*pi); 
peak_level_dB=20*log10(peak_level);
%plot(w,20*log10(H))
% 
% a1 = 14427.5;
% a2 = 355.3e6;
% 
% w = logspace(1,5,1000);
% freqs([ 0, a3],[1, a1, a2],w);
% 
% [H, W] = freqs([a3, 0],[1, a1, a2],w);
% [peak_level,indx] = max(abs(H));
% peak_freq = w(indx)/(2*pi) 
% peak_level_dB=20*log10(peak_level)