function [lambdaNext,beta0Next,betaNext,alphaS,nuS,muS] = svmIntervalFindNext0(x,y,rho,Sigma,alphaS,nuS,muS,iPlus,iMinus)

% finding the initial parameter values for the case n_+ > n_-
% return the following variables:
% lambdaNext: the lambda at which the next event occurs;
% beta0Next, betaNext, alphaS, nuS, nuS: parameter values at lambdaNext

[p,n] = size(x);

betaS = x*(alphaS.*y')+(nuS-muS);
temp = zeros(1,n);
temp(iPlus) = betaS'*x(:,iPlus) - rho*abs(betaS)'*Sigma(:,iPlus);
temp(iMinus) = betaS'*x(:,iMinus) + rho*abs(betaS)'*Sigma(:,iMinus);


iPlusMaxTemp = find(alphaS'>1e-5 & alphaS'<1 - 1e-5 & y == 1);
if length(iPlusMaxTemp) > 0
% Case 1: some plus points have alpha in (0,1)
  iPlusMax = iPlusMaxTemp(1);
else
% Case 2: all the plus points have alpha == 0 or 1
  validIndex = find(y == 1 & abs(alphaS -1)'<1e-5); % y == 1 and alpha = 1
  tempPlusMax = max(temp(validIndex));
  iPlusMax = find(temp == tempPlusMax & y == 1 & abs(alphaS -1)'<1e-5 );
end

% Do the same thing for the minus points
validIndex2 = find(y == -1 & abs(alphaS-1)'<1e-5); % y == -1 and alpha = 1
tempMinusMin = min(temp(validIndex2));
iMinusMin = find(temp == tempMinusMin & y == -1 & abs(alphaS - 1)'<1e-5);

xiP = x(:,iPlusMax);
xiM = x(:,iMinusMin);

APlus = Sigma(:,iPlusMax)'*abs(betaS);
AMinus = Sigma(:,iMinusMin)'*abs(betaS);

% get the lambda0 and beta0 where the first event occurs:
lambdaNext = 0.5*(-rho*(AMinus+APlus)+(xiP-xiM)'*betaS);
beta0Next = 1 + (rho*APlus-xiP'*betaS)/lambdaNext;
betaNext = betaS/lambdaNext;
