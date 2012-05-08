function [loss b b0] = xval(X,Y,S,lambda,rho,cv_split,num_cv_splits)
% cross-validation
%
% X = [n x p]: Data
% Y = [n x 1]: Labels. Each entry in {-1,1}.
% S = [n x p]: confidence intervals.
% lambda: regularization parameter
% rho: global uncertainty parameter
% cv_split: fraction of data to be tested on. To train on 75% of the data, for example, let cv_split = .75; to perform leave-one-out cross-validation, let cv_split = 1/n and num_cv_splits = n.
% num_cv_splits: number of times to run cross validation on random splits

loss = 0;
n = size(X,1);

% preprocess data so that labels are evenly distributed
I1 = Y==Y(1);
I2 = Y~=Y(1);
X1 = X(I1,:);
X2 = X(I2,:);
Y1 = Y(I1);
Y2 = Y(I2);
S1 = S(I1,:);
S2 = S(I2,:);
X(1:2:n,:) = X1;
X(2:2:n,:) = X2;
Y(1:2:n,1) = Y1;
Y(2:2:n,1) = Y2;
S(1:2:n,:) = S1;
S(2:2:n,:) = S2;

for i = 1:num_cv_splits

	% construct training and test data and labels
	nTe = floor(n*cv_split);
	nTr = n-nTe;
	iTe = 1:nTe + (i-1)*nTe;
	iTr = ~ismember(1:n,iTe);
	XTr = X(iTr,:);
	YTr = Y(iTr);
	XTe = X(iTe,:);
	YTe = Y(iTe);
	STr = S(iTr,:);

	loss = loss + svm(XTr,YTr,XTe,YTe,lambda,rho,STr);
end
loss = loss / num_cv_splits;

% compute b and b0 by training on entire dataset
[loss2 b b0] = svm(X,Y,X,Y,lambda,rho,S);
