o = 6; % LPF filter order
N = 1024; % # points on unit circle
FF = -0.5:1/N:0.5-1/N; % corresponding freq. axis
t2 = 0:1/100000 :1;

sig = csvread('fir_filter.csv');

F0 = [1.11 1.39 1.72 2.0 2.27 2.63 2.91 3.33 3.57 3.84].*0.1;
%sig = csvread('signal.csv');

%shift = .2; %inital frequency
 for i = 1:10 

hold on;
Wc = 2*pi*0.007; % LPF corner frequency
W0 = 2*pi*F0(i); % BPF center frequency change .22 to shift
[b,a] = butter(o,Wc/pi); % create 3rd order B'worth LPF
aplus = a.*exp(1i*W0*(0:o)); % rotate poles by W0
bplus = b.*exp(1i*W0*(0:o)); % rotate zeros by W0
aminus = a.*exp(-1i*W0*(0:o)); % rotate poles by -W0
bminus = b.*exp(-1i*W0*(0:o)); % rotate zeros by -W0
bb = conv(bplus,aminus) + conv(bminus,aplus); % BPF zeros
aa = conv(aplus,aminus); % BPF poles
aa = real(aa); % eliminate round-off error

y = zeros(1,100001);

for n = 1:10000
 y(n) = bb(1)*sig(n);
 
    for k = 2: length(bb)
        if(n+1 > k)
          y(n) = y(n) + bb(k)*sig(n-k+1) - aa(k)*y(n-k+1);
        end  
    end

end

figure(5)
    plot (t2,y)
    

% F(:,k) = filter(bb,aa,x);
figure(6)
 H_bpf = freqz(bb,aa,N,'whole'); % DFT of BPF
 plot(FF,20*log10(abs(fftshift(H_bpf)))); % plot DFT of BPF

 end

