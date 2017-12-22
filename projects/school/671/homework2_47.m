% Homework 2 prob 47 for 671
incr = 0.0001;
t = -1:incr:1;

x1 = 3*t.^2 - 1;
x2 = 5*t.^3 - 3*t;
x3 = 2*t.^2-t;


% x1 and x2
angleFunkyness(x1,x2,incr,t)
% x1 and x3
angleFunkyness(x1,x3,incr,t)
% x2 and x3
angleFunkyness(x3,x2,incr,t)
