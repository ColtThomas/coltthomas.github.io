% Homework 3 - Colt Thomas

%% MATLAB problem 1


% a.) Write	a	script	that	numerically	(not analytically	or	
% symbolically)	generates the	first	5	Legendre	polynomials	by	
% using	Gram-Schmidt orthogonalization on the set of vectors	
% {1,	t,	t2,	t3,	t4} over the interval [-1,1]. Plot each	of these 
% polynomials	for	-1	< t	< 1.


% hint: see pg 120 in the book
n = 10000;
increment = 0.0002;
t = linspace(-0.9999, 0.9999, 10000); % having the limits at -1 to 1 will cause problems with the weighing function
p = zeros(10000, 5);
for kk = 1:5
p(:, kk) = t.^(kk-1);
end

% part a - plot the polynomials
% we need to find q1 - q5. Remember that the purpose of doing Gram-Schmidt
% orthogonalization is to produce a set of orthonormal vectors

e_l = p; % normalized matrix of p. This will change as we iterate.
q_l = zeros(10000, 5); % our orthonormal vectors to be computed
q_l(:,1) = e_l(:,1)/normOp(e_l(:,1)); 

for idx=2:5
    e_l(:,idx) = p(:,idx); % redundant?
    
    for k = 1:idx-1
        e_l(:,idx) = e_l(:,idx) - innerProduct(p(:,idx),q_l(:,k))*q_l(:,k);
    end
    
   q_l(:,idx) = e_l(:,idx)/normOp(e_l(:,idx)); 
end

figure;
plot(t,q_l(:,1),t,q_l(:,2),t,q_l(:,3),t,q_l(:,4),t,q_l(:,5))

% part b - Linear Least Squares approximation of e^-t
% Now that we have an orthonormal set, we can find an approximation. See
% lecture 6 - pg 2. All we are doing is a projection of the funtion onto
% our Legrande polynomials 

x = exp(-t)';

% create the projection matrix P/find the Gramian

R_L = zeros(5,5); % we have 5 vector columns for our Legrande polynomials

for idx=1:5
    for k=1:5
       R_L(idx,k) = innerProduct(q_l(:,idx),q_l(:,k)); % may have to switch index?
    end
end

% find the cross correlation matrix

P_L = zeros(5,1);
for idx = 1:5
   P_L(idx,1) = innerProduct(x,q_l(:,idx)) ;
end

% Now just solve for C in R*C = P

C = R_L^(-1)*P_L;

% figure
% plot(t,x,t,C'*q');

% error_L = x'-C'*q';
% increment = 0.0002;
% norm_L = sqrt(sum(error_L.*error_L)*increment); % comes out to 4.7e-4

% Part c - Now find the Chebychev polynomials (see pg 120)
% We add a weighing function to do this by multiplying f(x) by 1/sqrt(1-t^2)
w = 1./sqrt(1-t.^2);

% similar to part a, but with our weighing function
e_c = p; % normalized matrix of p. This will change as we iterate.
q_c = zeros(10000, 5); % our orthonormal vectors to be computed
q_c(:,1) = e_c(:,1)/sqrt(sum(e_c(:,1).*w'.*e_c(:,1))*increment ); 
% q_c(:,1)= w*q_c(:,1);
for idx=2:5
    for k = 1:idx-1
        e_c(:,idx) = e_c(:,idx) - innerProduct(p(:,idx),q_c(:,k),w)*q_c(:,k);
%         e_c(:,idx) = e_c(:,idx) - sum(p(:,idx).*w'.*q_c(:,k))*increment*q_c(:,k);
    end
   
   q_c(:,idx) = e_c(:,idx)/normOp(e_c(:,idx),w); 
%     q_c(:,idx) = e_c(:,idx)/sqrt(sum(e_c(:,idx).*w'.*e_c(:,idx))*increment);
end
% figure;
% plot(t,q_c(:,1),t,q_c(:,2),t,q_c(:,3),t,q_c(:,4),t,q_c(:,5))


% Part d - 


x = exp(-t)';

% create the projection matrix P/find the Gramian

R_C = zeros(5,5); % we have 5 vector columns for our Legrande polynomials

for idx=1:5
    for k=1:5
       R_C(idx,k) = innerProduct(q_c(:,idx),q_c(:,k)); % may have to switch index?
    end
end

% find the cross correlation matrix

P_C = zeros(5,1);
for idx = 1:5
   P_C(idx,1) = innerProduct(x,q_c(:,idx)) ;
end

% Now just solve for C in R*C = P

C = R_C^(-1)*P_C;

figure
plot(t,x,t,C'*q_c');

error_C = x'-C'*q_c';
increment = 0.0002;
norm_C = sqrt(sum(error_C.*error_C)*increment);  % comes out to 4.7e-4



%% problem 2.8-3
% We want to do a linear regression of the following x,y coordinates:
x = [2,2.5,3,5,9];
y = [-4.2,-5,2,1,24.3];
hold on;
plot(x,y,'o') 
% Part b - Least Squares Line

% To do this we will find a solution y ~= ax + b using a leasts squares
% method. A way to do this is to solve for c in the equation y = Ac + e,
% where e is the error vector.
A = [x;ones(1,5)]';
% A = [x ones(length(x),1)];
% c = (A'*A)^(-1)*A'*y;
R = A'*A;
c= R'^(-1)*A'*y';

x_axis = 0:9;
y_axis = c(1)*x_axis+c(2);
plot(x_axis,y_axis);
title('Linear Regression Model');

% Part c - weighted least-squares

% look as eq 3.24 (pg 140) and example 3.8.1 (pg 149) to see how to do a
% weighted least-squares line
W = diag([10 1 1 1 10]);
x_w = x.*w;
y_w = y.*w;

A_w = [x_w;ones(1,5)]';
R_w = A_w'*W*A_w;
c_w= R_w'^(-1)*A_w'*W*y_w';

y_ax_w = c_w(1)*x_axis+c_w(2);
plot(x_axis,y_ax_w);
legend('Data','Least-Squares','Weighted Least Squares');
