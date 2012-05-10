function [Lambda_l,Beta0_l,Beta_l] = svmIntervalPath(x,y,rho,Sigma,iter_max)

% This function finds the regularization path of an interval SVM
% Inputs:
% x: transposed design matrix, rows represent features, column observations
% y: 1 by n row vector
% Sigma: the precision matrix of x, of the same dim of x
% rho: the precision weight
% iter_max: maximum break points

% Outputs:
% Lambda_l: the break points at which an event occurs
% Beta0_l, Beta_l: the parameter values at those break points
nPlus = sum(y == +1);
nMinus = sum(y == -1);

if nPlus < nMinus
  y = -y;
end

iPlus = find( y == +1);
iMinus = find( y == -1);

[Lambda_l,Beta0_l,Beta_l] = svmIntervalFindNext(x,y,rho,Sigma,iPlus,iMinus,iter_max);

if nPlus < nMinus
  Beta0_l = -Beta0_l;
  Beta_l = -Beta_l;
end
