F0 = 0; % center frequency (cycles/sample)
B = 0.05; % bandwidith (cycles/sample)
L = 51; % the length parameter L
N = 2*L+1; % the filter length
n = (-L:L)'; % the sample index
hideal = 2*B*cos(2*pi*F0*n).*sinc(B*n);
h1 = blackmanharris(N).*hideal; % window with Blackman-Harris window

sig = csvread('signal.csv');
t1 = 0:1/50010 :1;

y = zeros(1,10000+11);
f = zeros(108,1);
new= [f;sig];
new = new';
for n = 11:50000+11
    s = 0;
    for k = 1: length(h1)
       % if(10*n>i)
            n;
            k;
          s = s+ h1(k)*new(10*n-k);
         
       % end  
    end
    y(n) = s;
end

csvwrite('fir_filter.csv',y);

figure(3)
plot (t1,y)
legend('Out put of FIR : y');
   
figure(4)
N = 1000; % length of the DFTs
X = pwelch(y,rectwin(N),0,N,'twosided'); % Welch periodogram method
FF = -0.5:1/N:0.5-1/N; % frequency axis for the plot
plot(FF,10*log10(abs(fftshift(X)))); % create the plot, note the use of
axis([-0.5 0.5 -60 10]);
grid on; % fftshift to reorder X to align
xlabel('frequency (cycles/sample)'); % with the frequencies in FF.
ylabel('magnitude (dB)');
legend('DFT of y');

% IIR

o = 6; % LPF filter order
N = 1024; % # points on unit circle
FF = -0.5:1/N:0.5-1/N; % corresponding freq. axis
t2 = 0:1/10000 :1;

sig = csvread('fir_filter.csv');

F0 = [1.11 1.39 1.72 2.0 2.27 2.63 2.91 3.33 3.57 3.84].*0.1;

for r = 1:10 

hold on;
Wc = 2*pi*0.007; % LPF corner frequency
W0 = 2*pi*F0(r); % BPF center frequency change .22 to shift
[b,a] = butter(o,Wc/pi); % create 3rd order B'worth LPF
aplus = a.*exp(1i*W0*(0:o)); % rotate poles by W0
bplus = b.*exp(1i*W0*(0:o)); % rotate zeros by W0
aminus = a.*exp(-1i*W0*(0:o)); % rotate poles by -W0
bminus = b.*exp(-1i*W0*(0:o)); % rotate zeros by -W0
bb = conv(bplus,aminus) + conv(bminus,aplus); % BPF zeros
aa = conv(aplus,aminus); % BPF poles
aa = real(aa); % eliminate round-off error

z = zeros(1,10000+14);
d = zeros(1,12);
new1 = [d,sig];
for n = 14:10000+14
 %z(n) = bb(1)*sig(n);
 
    for k = 1: length(bb)
       % if(n+1 > k)
          z(n) = z(n) + bb(k)*new1(n-k) - aa(k)*z(n-k);
        %end  
    end
end

figure(5)
plot (t2,z)
legend('Output of IIR: z');
    

% F(:,k) = filter(bb,aa,x);
figure(6)
H_bpf = freqz(bb,aa,N,'whole'); % DFT of BPF
plot(FF,20*log10(abs(fftshift(H_bpf))));
% N = 1000; % length of the DFTs
% X = pwelch(z,rectwin(N),0,N,'twosided'); % Welch periodogram method
% FF = -0.5:1/N:0.5-1/N; % frequency axis for the plot
% plot(FF,20*log10(abs(fftshift(X)))) % create the plot, note the use of
% axis([-0.5 0.5 -60 10]);
% grid on; % fftshift to reorder X to align
% xlabel('frequency (cycles/sample)'); % with the frequencies in FF.
% ylabel('magnitude (dB)');
% legend('DFT of z');
% shift = shift + .02;
 end


   
    
    
