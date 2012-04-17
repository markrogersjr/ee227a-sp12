function L = cv(X,Y,Sigma,model)
% leave-one-out cross-validation
%
% X = [n x p]: Data
% Y = [n x 1]: Labels
% L in [0,inf]: Loss

Lambda = 0:.01:1;
Rho = 0:.01:1;
L = zeros(numel(Lambda),numel(Rho));
n = size(X,1);
for lambda = Lambda
	for rho = Rho
		for i = 1:n
			XTr = X(1:n ~= i,:);
			YTr = Y(1:n ~= i);
			XTe = X(i,:);
			YTe = Y(i);
			SigmaTr = X(1:n ~= i,:);
			L(lambda*100+1,rho*100+1) = svm(model,XTr,YTr,XTe,YTe,lambda,rho,SigmaTr);
		end
	end
end
