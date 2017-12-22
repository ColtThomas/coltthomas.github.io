function [ output ] = innerProduct(Vect1,Vect2,weight)
%innerProduct - takes the inner product of two same-sized vectors
 % TODO - find the page number for this in your book....

% a typical inner product will integrate the product of the two
% functions/vectors over their respective range, but <f,g> can also be
% computed as g^t * f * (interval increments)

% increment = 1/4; % for hw 2 p 77, we are dividing the function into 4ths
% increment = 0.001; % for hw 2 p 47
increment = 0.0002; % for hw 3 prob 1

% The weighing function is optional
if nargin < 3 
    output = Vect1' * Vect2 * increment;
else
    output = sum(Vect1.*weight'.*Vect2) * increment;
end

end

