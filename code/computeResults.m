function computeResults(iParams,fname,save_dname,params_fname)
% computeResults.m computes the loss of the SVM interval classifier when applied to data in fname. The result is stored in sname_prefix_iParam.mat, the parameters are loaded from params_fname, and iParams is a subset of the indices of the cell array Params, located in params_fname, to use.

if ~strcmp(save_dname(numel(save_dname)),'/')
	save_dname = [save_dname '/'];
end
load(fname);
cv_split = .1;
num_cv_splits = 1/cv_split;
load(params_fname);
if ~exist('S')
	S = zeros(size(X));
end

% preprocess data
[X Y S class_of_each_datapoint feature_names] = preprocess_data(X,Y,S,class_of_each_datapoint,feature_names);

for i = iParams
	lambda = Params{i}(1);
	rho = Params{i}(2);
	[loss b b0] = xval(X,Y,S,lambda,rho,cv_split,num_cv_splits);
	iParam = i;
	if i==1
		save([save_dname num2str(i,'%09d') '.mat'],'lambda','rho','loss','b','b0','iParam','feature_names','class_of_each_datapoint');
	else
		save([save_dname num2str(i,'%09d') '.mat'],'lambda','rho','loss','b','b0','iParam');
	end
end
