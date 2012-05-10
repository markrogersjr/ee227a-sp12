function [alpha,nu,mu] = svmIntervalInit(x,y,rho,Sigma,iPlus,iMinus)
[m,n] = size(x);
numNeg = length(iMinus);
cvx_quiet(true);
cvx_begin
  variable alpha(n);
  variable nu(m);
  variable mu(m);
  minimize(norm(x*(alpha.*y')+nu-mu));
  subject to
    alpha(iPlus)<=1;
    alpha(iPlus)>=0;
    alpha(iMinus) == 1;
    sum(alpha(iPlus))== numNeg;
    rho*(Sigma*alpha)>=mu+nu;
    mu>=0;
    nu>=0;
cvx_end;
    