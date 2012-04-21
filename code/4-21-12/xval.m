function loss = xval(X,Y,S,model,lambda,rho,cv_split,num_cv_splits,random_splits)
% cross-validation
%
% X = [n x p]: Data
% Y = [n x 1]: Labels. Each entry in {-1,1}.
% S = [n x p]: confidence intervals. 
% L = {num_cv_splits x 1}: cell array containing triples [lambda,rho,loss]
% cv_split: fraction of data to be tested on. To train on 75% of the data, for example, let cv_split = .75; to perform leave-one-out cross-validation, let cv_split = 1/n and num_cv_splits = n.
% num_cv_splits: number of times to run cross validation on random splits

loss = 0;
n = size(X,1);

% preprocess data so that labels are evenly distributed
if ~random_splits
	i1 = Y==Y(1);
	i2 = Y~=Y(1);
	X1 = X(i1,:);
	X2 = X(i2,:);
	Y1 = Y(i1);
	Y2 = Y(i2);
	X(1:2:n,:) = X1;
	X(2:2:n,:) = X2;
	Y(1:2:n,1) = Y1;
	Y(2:2:n,1) = Y2;
end

for i = 1:num_cv_splits
	nTe = floor(n*cv_split);
	nTr = n-nTe;
	
	% construct training and test data and labels
	if random_splits
		r = randperm(n);
		iTe = r(1:nTe);
		iTr = r((nTe+1):n);
		XTr = X(iTr,:);
		YTr = Y(iTr);
		XTe = X(iTe,:);
		YTe = Y(iTe);
		STr = S(iTr,:);
	else
		iTe = 1:nTe + (i-1)*nTe;
		iTr = ~ismember(1:n,iTe);
		XTr = X(iTr,:);
		YTr = Y(iTr);
		try,XTe = X(iTe,:);catch err,disp(err.message);keyboard;end
		YTe = Y(iTe);
		STr = S(iTr,:);
	end
	loss = loss + svm(model,XTr,YTr,XTe,YTe,lambda,rho,STr);
end
loss = loss / num_cv_splits;
