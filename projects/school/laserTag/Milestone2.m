% Transmitting signals

FreqPlayer1 = 2000; % player 4
FreqPlayer2 = 3330;  % player 8
SqrWaveT = linspace(0,0.2,0.2*100000);  % time for square wave

Player1Sqr= square(2*pi*FreqPlayer1*SqrWaveT);
Player2Sqr = square(2*pi*FreqPlayer2*SqrWaveT);
TotPlayer1 = Player1Sqr.*0.25;
TotPlayer2 = Player2Sqr.*0.25;
ConcSig = cat(2,zeros(1,20000),TotPlayer1,zeros(1,20000),TotPlayer2,zeros(1,20000));  

t = linspace(0,1,100000); 
NoiseFreq = 40e3; 
NoiseFreqSin = sin(2*pi*NoiseFreq*t); 
NoiseFreqSin = NoiseFreqSin./10 +0.5;  
Signal = ConcSig + NoiseFreqSin; 
Signal = round(Signal.*4095); 

%figure()
%plot(t,Signal);

fid = fopen('transmit_out.txt','w');
fprintf(fid,'Transmitted signal\n\n');
fprintf(fid,'%4d\n',Signal);
fclose(fid);

% ------------------------------------ FIR -------------------------------


F0 = 0; 
B = 0.05; 
L = 501; 
N = 2*L+1; 
c = (-L:L)'; 
hIdeal = 2*B*cos(2*pi*F0*c).*sinc(2*B*c);
h0 = chebwin(N).*hIdeal;

fname = 'data.txt';
fid = fopen(fname,'r');

% read and discard the 2 header lines
junk = fgetl(fid);
junk = fgetl(fid);    

% read the ADC data 
x = fscanf(fid,'%d');
x = x';
fclose(fid);

t1 = linspace(0,1,10000);
SignalFIR = [zeros(1,length(h0)), zeros(1,10000)];

 for i = 1:10000
    d = 0;
    for j = 1: length(h0)
        if(i>j)
         d = d+ h0(j)*x(10*i-j);
        end  
    end
    SignalFIR(i) = d;
 end
figure();

% Open FIR output file 
fid = fopen('FIR_out.txt','w');

fprintf(fid, 'FIR Output \n\n');
fprintf(fid, '%g\n', SignalFIR);
fclose(fid);

% ------------------------------------ IIR -------------------------------

fname = 'FIR_out.txt';
fid = fopen(fname,'r');

% read and discard the 2 header lines
junk = fgetl(fid);
junk = fgetl(fid);    

% read the ADC data samples
x = fscanf(fid,'%g');
x = x';

fclose(fid);


n = 6;
Wc = 2*pi*0.005; 
W0 = (2*pi).*[.111 .139 .172 .20 .227 .263 .291 .333 .357 .384];
[b,a] = butter(n,Wc/pi);
aa = zeros(13,10);
bb = zeros(13,10);

for i= 1:10
aplus = a.*exp(1i*W0(i)*(0:n)); 
bplus = b.*exp(1i*W0(i)*(0:n)); 
aminus = a.*exp(-1i*W0(i)*(0:n));
bminus = b.*exp(-1i*W0(i)*(0:n)); 
bb(:,i) = conv(bplus,aminus) + conv(bminus,aplus);
aa(:,i) = conv(aplus,aminus); 
aa = real(aa);
end

xTot = [zeros(1,length(aa(:,1))) , x]; 
yTot = zeros(10, length(xTot)); 

for g = 1:10
    for h = length(aa(:,1))+ 1:length(xTot) 
        bTot = 0;
        for k = 1:length(bb(:,1))
            bTot = bTot+bb(k,g) * xTot(h-k+1);
        end
        aTot = 0;
        for k = 2:length(bb(:,1))
            aTot = aTot + aa(k,g) * yTot(g, h-k+1);
        end
        yTot(g,h) = bTot - aTot;
    end
end

Total = zeros(10,1);
Power = zeros(10,10007);
max = 0;
extra = 0;
NumberPlay = 0;
for l = 1:10
    for m = 1: length(yTot(1,:));
    Power(l,m) = yTot(l,m)^2; 
    Total(l) = Total(l) + Power(l,m); 
    end
    extra = Total(l); 
    if (extra >= max) 
        max = extra; 
        NumberPlay = l;
    end
end

PowerRed = zeros(10,10000); 
for n = 1:10
    for o = length(aa(:,1))+1:length(yTot)
        PowerRed(n,o - length(aa(:,1))) = Power(n,o);
    end
end

fvtool(h0,'Fs',10000);
title('frequenc Response FIR');

figure();
plot(t,Signal)
title('Transmitter Signal');
t2=linspace(0,1,11003);
figure();
plot (t2,SignalFIR)
title('FIR Output');

figure();
hold on;
for p= 1:10
    
Points = 1024; 
Axis = -0.5:1/Points:0.5-1/Points; 
BPF = freqz(bb(:,p),aa(:,p),Points,'whole'); 
plot(Axis,20*log10(abs(fftshift(BPF)))); 


grid on;
xlabel('cycles/sample(frequency)');
ylabel('dB(magnitude)');
set(gca,'XTick',-0.5:0.1:0.5);
axis([0 0.5 -60 3]);
end


hold on;
title('frequency Response IIR');
figure();


surf(PowerRed);
title('Players Power Levels');




