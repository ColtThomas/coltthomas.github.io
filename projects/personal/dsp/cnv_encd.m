function output=cnv_encd(g,k0,input)

% This is an example of how to implement a convolutional encoder
% Parameters:
% G - The generator sequences of the convolutional code, which is an MxN matrix. M rows represents each Mth generator
%     sequence of the conv code and N represents the length of each sequence
% K0 - sequence of information bits. Think of it as the number of info bits being shifted in at a time.
% input - binary information sequence you wish to encode of size 1X(multiple of N)

% input handling
if rem(length(input),k0) >0
    input=[input,zeros(size(1:k0-rem(length(input),k0)))];
end
n=length(input)/k0;

if rem(size(g,2),k0) > 0 
    error('Invalid size for G')
end

% determine length and the channel input sequence length n0
l=size(g,2)/k0;
n0=size(g,1);

% add extra zeros
u=[zeros(size(1:(l-1)*k0)),input,zeros(size(1:(l-1)*k0))];

% generate uu, a matrix whose colmns are the contents of conv.encoder at various clock cycles
u1=u(l*k0:-1:1);
for i=1:n+l-2
    u1 = [u1,u((i+l)*k0:-1:i*k0+1)];
end

uu = reshape(u1,l*k0,n+l-1);

output = reshape(rem(g*uu,2),1,n0*(l+n-1));
end

% g= [[0,0,1,0,1,0,0,1],[0,0,0,0,0,0,0,1],[1,0,0,0,0,0,0,1]];
% k0 = 2
% 
