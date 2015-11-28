%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            % Transmitter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Square wave
    f1 = 1110;                       %the frequency of the first square wave(player 1)
    f2 = 2000;                       %the frequency of the second square wave(player 4)
    t = 0:1e-5:0.2 - 1e-5;           % 100kHz sample rate (0.2 / 1e-5 = 100e3)
    sqrSig1 = square(2*pi*f1 * t);   %Square wave function that has a period of 2pi*f over t time
    sqrSig1 = (sqrSig1)./4;         %This is to resize the square signal to an acceptable level
    sqrSig2 = square(2*pi*f2*t);
    sqrSig2 = (sqrSig2)./4;
    sqrSig = [zeros(1,20e3), sqrSig1, zeros(1,20e3), sqrSig2, zeros(1,20e3)];%concatenating the signals to form a 1 second signal
    t = 0:1e-5:1 - 1e-5;

%Sine wave
   Fc = 40e3;                       % sine wave frequency in hertz
   y = sin(2*pi*Fc*t) .* .1;       %Similar to square function.  .* 0.1 divides 
                                    %the array by 10 so we only have a little
                                    %noise and still see a square wave (it
                                    %oscillates from -1 to 1 initially)
   y = y + 0.5;                     %this is to center the signal at 0.5 voltage level
   
%Combine the square wave and sine wave to have noisy signal
   Sig = sqrSig+y;
   Sig = Sig.* (2^(12)-1);          %changing the range to 0-4096
   
%Writing the signal to disk
fname = 'transmit_out.txt'; 
fid = fopen(fname,'w');

fprintf(fid,'****** Simulated received signal ADC output. Offset binary, unipolar ****** \n\n');
fprintf(fid,'%4d\n',int32(Sig));

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
                            %FIR Filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% f = [0 0.04 0.08 0.9 0.95 1];
% a = [1.0 1.0 0.0 0.0 0.0 0];
% b = firpm(50,f,a);

%the window
L = 1001; % the length parameter L
N = 2*L+1;
B = .05;
n = (-L:L)'; % the sample index
Nd = 2048; % number of points around unit circle
hideal = 2*B.*sinc(2*B*n);
h0 = rectwin(N).*hideal; % window with chebyshev window

%reading the signal from disk
fname = 'data.txt';
fid = fopen(fname,'r');

% read and discard the 2 header lines
junk = fgetl(fid);
junk = fgetl(fid);    

% read the ADC data samples
x_in = fscanf(fid,'%d');
x_in = x_in';


fclose(fid);

t2 = 0:1e-4 :1 -1e-4;


lengthN = 100000;
filteredSig = zeros(1,lengthN/10 );
for n = 1:lengthN / 10
    s = 0;
    for i = 1:length(h0)
        if(n>i)
        s = s + h0(i)*x_in(10*n - i);
        end
    end
    filteredSig(n) = s;
end

%Writing the output to disk
fid = fopen('FIR_out.txt','w');

fprintf(fid,'****** Simulated received signal decimating FIR output. Floating point ****** \n\n');
fprintf(fid,'%g\n',filteredSig);

fclose(fid);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %IIR filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%reading the FIR output from disk
fname = 'FIR_out.txt';

fid = fopen(fname,'r');

% read and discard the 2 header lines
junk = fgetl(fid);
junk = fgetl(fid);    

% read the ADC data samples
x_in = fscanf(fid,'%g');
x_in = x_in';

fclose(fid);

n = 3; % LPF filter order (the BPF order would be 6)
Wc = 2*pi*0.005; % LPF corner frequency
W0 = (2*pi).*[.111 .139 .172 .20 .227 .263 .291 .333 .357 .384];% BPF center frequencies
[b,a] = butter(n,Wc/pi); % create 3rd order B’worth LPF
aa = zeros(7,10);
bb = zeros(7,10);
for i= 1:10
aplus = a.*exp(1i*W0(i)*(0:n)); % rotate poles by W0
bplus = b.*exp(1i*W0(i)*(0:n)); % rotate zeros by W0
aminus = a.*exp(-1i*W0(i)*(0:n)); % rotate poles by -W0
bminus = b.*exp(-1i*W0(i)*(0:n)); % rotate zeros by -W0
bb(:,i) = conv(bplus,aminus) + conv(bminus,aplus); % BPF zeros
aa(:,i) = conv(aplus,aminus); % BPF poles
aa = real(aa);
end

x_in_pad=[ zeros(1,length(aa(:,1))) , x_in];

y_pad=zeros(10, length(x_in_pad));
for i = 1:10
    for n=length(aa(:,1))+1:length(x_in_pad)
        bsum = 0;
        for k=1:length(bb(:,1))
            bsum = bsum+bb(k,i)*x_in_pad(n-k+1);
        end
        asum = 0;
        for k=2:length(bb(:,1))
            asum = asum+aa(k,i)*y_pad(i, n-k+1);
        end
        y_pad(i,n)=bsum-asum;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   %Power Integrator and max select
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sumVec = zeros(10,1);
powerVec_pad = zeros(10,10007);
maxVal = 0;
newVal = 0;
playerNum = 0;
for p = 1:10
    for s= 1: length(y_pad(1,:));
    powerVec_pad(p,s) = y_pad(p,s)^2;
    sumVec(p) = sumVec(p) + powerVec_pad(p,s);
    end
    newVal = sumVec(p);
    if (newVal >= maxVal) 
        maxVal = newVal;
        playerNum = p;
    end
end

powerVec = zeros(10,10000);
for n = 1:10
    for i = length(aa(:,1))+1:length(y_pad)
        powerVec(n,i - length(aa(:,1))) = powerVec_pad(n,i);
    end
end


%Plots
figure(1);
plot(t,Sig)
title('Transmitter Signal');

figure(2);
plot (t2,filteredSig)
title('FIR output');

figure(3);
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


fvtool(h0,'Fs',10000);
title('FIR frequency Response');