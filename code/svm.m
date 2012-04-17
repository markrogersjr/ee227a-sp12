function L = svm(model,XTr,YTr,XTe,YTe,lambda,rho,Sigma)
% if argument is unused, just pass []. Loss function used: sign(y(i) * f(x(i)))
%
% INPUTS
% 
% model = 'path', 'interval', or 'combined': indicates model to use
% XTr = [n x p]: training data with n points and p features
% YTr = [n x 1]: training labels
% XTe
% lambda = nonnegative scalar: regularization parameter
% rho = nonnegative scalar: global uncertainty parameter
% Sigma = [n x p]: confidence intervals
%
% OUTPUTS
%
% L = scalar (loss): 

% estimate beta, beta0, xi 
if strcmp(model,'path')
	cvx_begin
		variable beta(p);
		variable beta0(1);
		variable xi(p);
		minimize xi'*ones(p,1) + lambda/2*norm(beta,2)^2
		subject to
			1 - YTr .* (beta0+XTr*beta) <= xi;
			xi >= 0;
	cvx_end
elseif strcmp(model,'interval')
	cvx_begin
		variable beta(p);
		variable beta0(1);
		variable xi(p);
		minimize xi'*ones(p,1)
		subject to
			YTr .* (XTr*beta + beta0) >= 1 - xi + rho*Sigma*abs(beta);
			xi >= 0;
	cvx_end
elseif strcmp(model,'combined')
	cvx_begin
		variable beta(p);
		variable beta0(1);
		variable xi(p);
		minimize xi'*ones(p,1) + lambda/2*norm(beta,2)^2
		subject to
			xi >= 1 - YTr .* (beta0 + XTr*beta) + rho*Sigma*abs(beta);
			xi >= 0;
	cvx_end
end

% compute loss L
f = @(x) beta0 + x'*beta;
l = @(x,y,f) (1 - sign(y .* f(x))) / 2; % 0-1 loss function
L = sum(l(XTe',YTe,f)) / numel(YTe);
