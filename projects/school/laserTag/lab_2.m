% 
% % First player signal
% 
%     % The player frequencies are stored in an array for quick modification
%     player_frequencies = [1110,1390,1720,2000,2270,2630,2910,3330,3570,3840];
%     f = player_frequencies(5);                  
%     
%     % With the frequency selected we create the square wave 
%     t = 0:1e-5:(.2-1e-5);               % 100kHz sample rate (.2 / 2e-6 = 100e3 ; our array increments at 2e-6 from 0 to .2)
%     x1 = square(2*pi*f*t);              %Square wave function that has a period of 2pi*f over t time
%     x1 = (x1).*.07;                       % This gives us about 275mVpp square wave
%     x1 = [zeros(1,40e3),x1,zeros(1,40e3)]; %x + 1 makes it oscillate from 0 to 2, and ./2
%     t = 0:1e-5:(1.0-1e-5);              %divides every element in the array x by 2, and
%                                         %then it oscillates about 0.5Vpp
% % Second player signal
%     f = player_frequencies(8);  
%     t = 0:1e-5:(.2-1e-5);
%     x2 = square(2*pi*f*t);       
%     x2 = (x2).*0.1;                 %10dB ratio
%     x2 = [zeros(1,40e3),x2,zeros(1,40e3)]; 
%     t = 0:1e-5:(1.0-1e-5);
%     
% %Sine wave
%    Fc = 40e3;                 % sine wave frequency in hertz
%    y = sin(2*pi*Fc*t) .*.1;   %Similar to square function.  .* 0.1 divides 
%    y = (y+.5);                %the array by 10 so we only have a little
%                               %noise and still see a square wave (it
%                               %oscillates from -1 to 1 initially)
%    
% %Combine the square wave and sine wave to have noisy signal
%    x = x1+x2+y;
%    scale = 2^12-1;
%    x = scale * x;
%    originalSig = x;
%    
%    
% %This writes our generated square wave out to a text file
% fid = fopen('transmit_out.txt','w');
% 
% fprintf(fid,'****** Simulated received signal ADC output. Offset binary, unipolar ****** \n\n');
% fprintf(fid,'%4d\n',int32(x));
% 
% fclose(fid);
% 
% fid = fopen('receiverTest1b.txt','r');
% % fid = fopen('transmit_out.txt','r');
% 
% % read and discard the 2 header lines
% junk = fgetl(fid);
% junk = fgetl(fid);    
% 
% % read the ADC data samples
% originalSig = fscanf(fid,'%d');
% 
% fclose(fid);
% 
% F0 = 0.0; % center frequency (cycles/sample)
% B = 0.115; % bandwidith (cycles/sample)
% L = 34; % the length parameter L
% N = 2*L+1; % the filter length
% n = (-L:L)'; % the sample index
% hideal = 2*B*cos(2*pi*F0*n).*sinc(B*n);
% h = chebwin(N).*hideal; % window with chebyshev window
% 
% hh = h';
% dlmwrite('fircoeff.dat',hh, 'delimiter', ',', 'precision', 15);
% type fircoeff.dat
% 
% lengthN = 100000;
% decimation_factor = 10;
% 
% % we initiallize our lowpass filtered signal
% lowfilterSig = zeros(1,lengthN/decimation_factor ); 
% 
% % this will be the time scale for plotting lowfilterSig
% t_decimated = 0: 1e-4:1-1e-4; 
% 
% % this is where we decimate the input signal and convolve it
% for n = 1:lengthN / decimation_factor
%     s = 0;
%     for i = 1:length(h)
%         if(n>i)
%         s = s + h(i)*originalSig(decimation_factor*n - i);
%         end
%     end
%     lowfilterSig(n) = s;
% end
% thisisit = lowfilterSig';
% 
% fo = [0.111,0.139,0.172,0.2,0.227,0.263,0.291,0.333,0.357,0.384];
% max_player = 0;
% max_val=0;
% power_axis = zeros(length(fo),length(lowfilterSig));
% % hold on
% for k = 1:10,
%     new = newfilter(fo(k), lowfilterSig,k);
%     max_val = max(new);
%     for j=1:length(new)
%     power_axis(k,j) = new(j);
%     end
%     
%     if max_val > max_player
%         max_player = new;
%         Player = k;
%     end
% end
% 
% figure(4)
% surf(power_axis);
% xlabel('sample');
% ylabel('player');
% zlabel('signal power');


% Transmitting signals

clear all;
close all;

f_sqr1 = 2000; % player 4
f_sqr2 = 1110;  % player 1
t_sqr = linspace(0,0.2,0.2*100000);  % time for square wave

sqr1 = square(2*pi*f_sqr1*t_sqr).*0.25;
sqr2 = square(2*pi*f_sqr2*t_sqr).*0.25;
sqr = cat(2,zeros(1,20000),sqr1,zeros(1,20000),sqr2,zeros(1,20000));  % concatinating both sq. signals

t = linspace(0,1,100000); 
f_sn = 40e3;   % noise frequency
sn = sin(2*pi*f_sn*t); 
sn = sn./10 +0.5;  % noise

sig = sqr + sn;  % adding noise to square signal
sig = round(sig.*4095);  % final signal giving ADC values

fid = fopen('transmit_out.txt','w');

fprintf(fid,'Transmitted signal\n\n');
fprintf(fid,'%4d\n',sig);

fclose(fid);

%%%%%  FIR  %%%%%

F0 = 0; % center frequency (cycles/sample)
B = 0.125; % bandwidith (cycles/sample)
L = 39; % the length parameter L
N = 2*L+1; % the filter length
n = (-L:L)'; % the sample index
hideal = 2*B*cos(2*pi*F0*n).*sinc(2*B*n);
h0 = chebwin(N).*hideal; % window with Chebyshev window

hh = h0';
dlmwrite('fircoeff.dat',hh,'delimiter',',','precision',15);
type fircoeff.dat

fname = 'data.txt';

fid = fopen(fname,'r');

% read and discard the 2 header lines
junk = fgetl(fid);
junk = fgetl(fid);    

% read the ADC data samples
x_in = fscanf(fid,'%d');
x_in = x_in';
fclose(fid);

lgth = 200-23;
t1 = linspace(0,1,lgth);
FIRsig = [zeros(1,length(h0)), zeros(1,lgth)];

 for n = 1:20
    s = 0;
     for k = 1: length(h0)
         if(n>k)
           s = s+ h0(k)*x_in(10*n-k);
        end  
     end
     FIRsig(n) = s;
 end

fid = fopen('FIR_out.txt','w');

fprintf(fid, 'FIR Output \n\n');
fprintf(fid, '%g\n', FIRsig);
fclose(fid);

%%% IIR %%%

fname = 'FIR_out.txt';
fid = fopen(fname,'r');

% read and discard the 2 header lines
junk = fgetl(fid);
junk = fgetl(fid);    

% read the ADC data samples
x_in = fscanf(fid,'%g');
x_in = x_in';

fclose(fid);

n = 7; % LPF filter order
Wc = 2*pi*0.01; % LPF corner frequency
%W0 = 2*pi*0.2; % BPF center frequency
W0 = (2*pi).*[.11111 .13889 .17241 .20 .22727 .26316 .29412 .33333 .35714 .38462];
[b,a] = butter(n,Wc/pi); % create 3rd order B’worth LPF
aa = zeros(2*n+1,10);
bb = zeros(2*n+1,10);

for i= 1:10
aplus = a.*exp(1i*W0(i)*(0:n)); % rotate poles by W0
bplus = b.*exp(1i*W0(i)*(0:n)); % rotate zeros by W0
aminus = a.*exp(-1i*W0(i)*(0:n)); % rotate poles by -W0
bminus = b.*exp(-1i*W0(i)*(0:n)); % rotate zeros by -W0
bb(:,i) = conv(bplus,aminus) + conv(bminus,aplus); % BPF zeros
aa(:,i) = conv(aplus,aminus); % BPF poles
aa = real(aa);
end

aaa = aa';
dlmwrite('iiracoeff.dat',aaa,'delimiter',',','precision',15);
type iiracoeff.dat
bbb = bb';
dlmwrite('iirbcoeff.dat',bbb,'delimiter',',','precision',15);
type iirbcoeff.dat

x_pad = [zeros(1,length(aa(:,1))) , x_in]; % adding history in the output of FIR

y_pad = zeros(10, length(x_pad)); % the output of IIR

for i = 1:10
    for n = length(aa(:,1))+ 1:length(x_pad) % starts the index after the zeros.
        bsum = 0;
        for k = 1:length(bb(:,1))
            bsum = bsum+bb(k,i) * x_pad(n-k+1);
        end
        asum = 0;
        for k = 2:length(bb(:,1))
            asum = asum + aa(k,i) * y_pad(i, n-k+1);
        end
        y_pad(i,n) = bsum - asum;
    end
end

sum = zeros(10,1);
power_pad = zeros(10,10007);
max = 0;
new = 0;
playerNum = 0;
for p = 1:10
    for s = 1: length(y_pad(1,:));
    power_pad(p,s) = y_pad(p,s)^2; % sqaures all the samples
    sum(p) = sum(p) + power_pad(p,s); % adds all the samples
    end
    new = sum(p); 
    if (new >= max) % finds the maximum power out of the 10 players
        max = new; 
        playerNum = p;
    end
end

powerVec = zeros(10,10000); % since I had bunch of zeros
for n = 1:10
    for i = length(aa(:,1))+1:length(y_pad)
        powerVec(n,i - length(aa(:,1))) = power_pad(n,i);
    end
end

fvtool(h0,'Fs',10000);
title('FIR frequency Response');

figure();
plot(t,sig)
title('Transmitter Signal');
t2=linspace(0,1,11003);
figure();


figure();
hold on;
for i= 1:10
N = 1024; % # points on unit circle
FF = -0.5:1/N:0.5-1/N; % corresponding freq. axis
H_lpf = freqz(b,a,N,'whole'); % DFT of LPF
H_bpf = freqz(bb(:,i),aa(:,i),N,'whole'); % DFT of BPF


plot(FF,20*log10(abs(fftshift(H_bpf)))); % plot DFT of BPF
grid on;
xlabel('frequency (cycles/sample)');
ylabel('magnitude (dB)');
set(gca,'XTick',-0.5:0.1:0.5);
axis([0 0.5 -60 3]);
end
hold off;
title('IIR frequency Response');
figure(4);
surf(powerVec);
title('Players Power Levels');




