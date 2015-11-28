


L = .3e-3;      % .3 uH
Rs = 50;        % 50 ohms
Rl = 100;         % 8 ohms
Rg = 10*Rl;     % 80 ohms
C = 44.7e-6;    % 44.7 uF
Sf = 9.312e-3; % scaling factor
%These are roots of the characteristic equation
P1 = -1/(2*Rl*C) + sqrt(((1/(2*Rl*C))^2) - 1/(L*C));
P2 = -1/(2*Rl*C) - sqrt(((1/(2*Rl*C))^2) - 1/(L*C));

%t is the interval for which we plot
t = linspace(-.001,.01,1000);
t0 = .001;
const = (1/(P1-P2))*(1/(C*(Rs+Rg)));
%h is the impulse response of system
h = (const)*(Sf)*((P1*exp(P1*t) - P2*exp(P2*t))).*(t>0);
Vs = rectangularPulse(-.001,0.01,t);
VL =(const) * ((exp(P2*(t-t0))-exp(P1*(t-t0))).*(t>t0) +(exp(P1*(t))-exp(P2*(t))).*(t>0));
VL_measured = VL * Sf;
%plot(t,h);

% This is part 4
%plot(conv(Vs,h));

%plot( t,VL);
plot(t,VL_measured);
xlabel('Time (s)');
ylabel('Volts (V)');




