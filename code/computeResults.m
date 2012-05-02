function computeResults(fname,sname_prefix,params_fname,iParam)
% computeResults.m computes the loss of the SVM interval classifier when applied to data in fname. The result is stored in sname_prefix_iParam.mat, the parameters are loaded from params_fname, and iParam is the index of the cell array Params, located in params_fname, to use.

load(fname);
cv_split = .1;
num_cv_splits = 1/cv_split;
load(params_fname);
lambda = Params{iParam}(1);
rho = Params{iParam}(2);
if ~exist('S')
	S = zeros(size(X));
end


% normalize data via quantile ranking
[X Y S] = quantile_ranking(X,Y,S);

% if multiclass data, then choose the two classes with the most datapoints
class_indices = 1:max(Y);
class_freqs = zeros(size(class_indices));
for i = class_indices
	class_freqs(i) = numel(find(Y==i));
end
[temp class_indices] = sort(class_freqs,'descend');
index_of_first_class = class_indices(1);
index_of_second_class = class_indices(2);
I1 = find(Y==index_of_first_class);
I2 = find(Y==index_of_second_class);
I1 = I1(1:numel(I2));
Y1 = Y(I1) ./ Y(I1) * (1);
Y2 = Y(I2) ./ Y(I2) * (-1);
X1 = X(I1,:);
X2 = X(I2,:);
S1 = S(I1,:);
S2 = S(I2,:);
X = [X1;X2];
Y = [Y1;Y2];
S = [S1;S2];
valid_feature_indices = zeros(1,size(X,2));
for i = 1:size(X,2)
	valid_feature_indices(i) = all(~isnan(X(:,i)));
end
valid_feature_indices = logical(valid_feature_indices);
X = X(:,valid_feature_indices);
S = S(:,valid_feature_indices);
loss = xval(X,Y,S,lambda,rho,cv_split,num_cv_splits);
save([sname_prefix '_'  num2str(iParam,'%03d') '.mat'],'lambda','rho','loss','iParam');

