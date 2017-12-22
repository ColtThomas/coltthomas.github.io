% Practice: Projection Theorem

% look on page 1 of lecture 5 notes, or pg 116 in your book. This is a
% simple projection of one vector onto another (as long as they are the
% same dimensions, or plug in 0 to reduce dimensions).

x = [1;1;1;1;1];
y = [2;4;6;-4;6];

% The projection matrix P can take a matrix x and project it onto y.

P = 1/(x'*x)*(x*x');

% simply multiply this by y

Y_x = P*y