% Homework 2 prob 77 for 671

% Declaration of our 4 functions AS COLUMN VECTORS
P1 = [1;1;1;1];
P2 = [1;1;0;1];
P3 = [1;1;0;0];
P4 = [1;0;1;1];

% Perform the Gram-Schmidt orthogonalization by normalizing each vector,
% with respect to each other. This is a recursive process.

Q1 = P1/normOp(P1); % custom norm function

e2 = P2 - innerProduct(P2,Q1)* Q1;

Q2 = e2/normOp(e2);

e3 = P3 - innerProduct(P3,Q1)* Q1 - innerProduct(P3,Q2)* Q2;

Q3 = e3/normOp(e3);

e4 = P4 - innerProduct(P4,Q1)* Q1 - innerProduct(P4,Q2)* Q2 - innerProduct(P4,Q3)* Q3;

Q4 = e4/normOp(e4); 

% FUNCTION CODE FOR REFERENCE

% function [ output ] = innerProduct(Vect1,Vect2)
% %innerProduct - takes the inner product of two same-sized vectors
%  % TODO - find the page number for this in your book....
% 
% % a typical inner product will integrate the product of the two
% % functions/vectors over their respective range, but <f,g> can also be
% % computed as g^t * f * (interval increments)
% 
% increment = 1/4; % for hw 2, we are dividing the function into 4ths
% output = Vect1' * Vect2 * increment;
% end

% function [ output_args ] = normOp( input_args )
% output_args = sqrt(innerProduct(input_args,input_args));
% end

% Plots - this is something that I need to figure out how to do....

t = 0:0.001:1;
ln = length(t);
b(1,1:floor(ln/4)) = 1;
b(2,floor(ln/4)+1:floor(ln/2)) = 1;
b(3,floor(ln/2)+1:floor(3*ln/4)) = 1;
b(4,floor(3*ln/4)+1:ln) = 1;

subplot(2,2,1);
plot(t,Q1'*b);
title('q1(t)');

subplot(2,2,2);
plot(t,Q2'*b);
title('q2(t)');

subplot(2,2,3);
plot(t,Q3'*b);
title('q3(t)');

subplot(2,2,4);
plot(t,Q4'*b);
title('q4(t)');