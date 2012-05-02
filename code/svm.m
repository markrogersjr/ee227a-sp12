function loss = svm(XTr,YTr,XTe,YTe,lambda,rho,S)
% if argument is unused, just pass []. Loss function used: sign(y(i) * f(x(i)))
%
% INPUTS
% 
% XTr = [n x p]: training data with n points and p features
% YTr = [n x 1]: training labels.  Each entry in {-1,1}.
% XTe = [n' x p]: test data
% YTe = [n' x 1]: test labels.  Each entry in {-1,1}.
% lambda = nonnegative scalar: regularization parameter
% rho = nonnegative scalar: global uncertainty parameter
% S = [n x p]: confidence intervals
%
% OUTPUTS
%
% loss = scalar: loss

% estimate b, b0, xi
[n p] = size(XTr);
cvx_begin
	variable b(p);
	variable b0(1);
	variable xi(n);
	minimize(xi'*ones(n,1) + lambda/2*b'*b)
	subject to
		xi >= 1 - YTr .* (b0 + XTr*b) + rho*S*abs(b);
		xi >= 0;
cvx_end

% compute loss l
f = @(x) b0 + x'*b;
l = @(x,y,f) (1 - sign(y .* f(x))) / 2; % 0-1 loss function
loss = sum(l(XTe',YTe,f)) / numel(YTe);
