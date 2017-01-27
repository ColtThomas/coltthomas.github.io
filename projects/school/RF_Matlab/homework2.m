Z_L = 75; % The Load impedance of the two antennas.
Z_0 = 50; % The characteristic impedance of the T-Line.


d_1 = 0.2; % The distance in wavelengths between the juncture and the
 % antennas.
d_2 = 0.2; % The distance in wavelengths between the juncture and
 % beginning of the T-Line.
beta_d_1 = 2*pi*d_1; % Beta*d1
beta_d_2 = 2*pi*d_2; % Beta*d2
%
% The values that will be calculated
% Z_in1,Z_in2 % the input impedance of the antenna-terminated line, at
 % the parallel juncture.
% Z_L_prime % Z_in1 in parallel with Z_in2.
% Z_in % The input impedance of the T-line.
% 2)
Z_in1 = Z_d(Z_0,Z_L,beta_d_1) % INSERT CODE HERE % Calculate Z_in1
Z_in2 = Z_d(Z_0,Z_L,beta_d_2) % INSERT CODE HERE % Calculate Z_in2
% 3)
Z_L_prime = Z_in1*Z_in2/(Z_in1+Z_in2) % INSERT CODE HERE % Calculate Z_L_prime
% 4)

beta_d_3 = 0.3*2*pi;
Z_in = Z_d(Z_0,Z_in1*Z_in2/(Z_in1+Z_in2),beta_d_3)% INSERT CODE HERE % Calculate Z_in
