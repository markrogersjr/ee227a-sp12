function [beta0,beta,e,t,alpha,gamma,c,v,u,margin,obj_val] = svmInterval(x,y,Sigma,rho,C)
% brute-force cvx way of fitting interval svm
% x: transposed design matrix, rows represent features, column observations
% y: 1 by n row vector
% Sigma: the precision matrix of x, of the same dim of x
% rho: the precision weight
% C: 1/lambda

% important outputs are
% beta0: the intercept
% beta: the classifier weights

lambda = 1/C;
[m,n] = size(x);
cvx_quiet(true);
cvx_begin
 variable e(n);
 variable beta(m);
 variable beta0;
 variable t(m);
 dual variables alpha gamma v u c;
 minimize(sum(e)+lambda*.5*beta'*beta);
 subject to
  
  alpha:  1 - (y.*(beta0+beta'*x))'+ rho*Sigma'*t-e<=0;
  gamma:  e >= 0;
  u: t-beta>=0;
  v: beta+t>=0;
  c: t>=0;

cvx_end

obj_val = cvx_optval;
margin = (y.*(beta0+beta'*x))';


