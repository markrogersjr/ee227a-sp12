function computeResults(iParams,fname,save_dname,params_fname)
% computeResults.m computes the loss of the SVM interval classifier when applied to data in fname. The result is stored in sname_prefix_iParam.mat, the parameters are loaded from params_fname, and iParam is the index of the cell array Params, located in params_fname, to use.

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

% MATLAB cell arrays are dumb so I have to do something tricky to update class_of_each_datapoint
class_of_each_datapointOLD = class_of_each_datapoint;
class_of_each_datapoint = cell(numel(I1)+numel(I2),1);
for i = 1:numel(I1)
	class_of_each_datapoint1{i} = class_of_each_datapointOLD{I1(i)};
end
for i = 1:numel(I2)
	class_of_each_datapoint{i+numel(I1)} = class_of_each_datapointOLD{I2(i)};
end

% remove columns containing all zeros or containing some NaNs
valid_feature_indices = zeros(1,size(X,2));
is_valid_feature = @(r) (  numel(find(isnan(r)))==0  ) && (  numel(find(r))>0  );
for i = 1:size(X,2)
	valid_feature_indices(i) = is_valid_feature(X(:,i));
end
valid_feature_indices = find(valid_feature_indices);
X = X(:,valid_feature_indices);
S = S(:,valid_feature_indices);

% MATLAB cell arrays are dumb so I have to do something tricky to update class_of_each_datapoint
feature_namesOLD = feature_names;
feature_names = cell(1,numel(valid_feature_indices));
for i = 1:numel(feature_names)
	feature_names{i} = feature_namesOLD{valid_feature_indices(i)};
end

% normalize data via quantile ranking
[X Y S] = quantile_ranking(X,Y,S);

for i = iParams
	lambda = Params{i}(1);
	rho = Params{i}(2);
	[loss b b0] = xval(X,Y,S,lambda,rho,cv_split,num_cv_splits);
	iParam = i;
	if i==1
		save([save_dname num2str(i,'%03d') '.mat'],'lambda','rho','loss','b','b0','iParam','feature_names','class_of_each_datapoint');
	else
		save([save_dname num2str(i,'%03d') '.mat'],'lambda','rho','loss','b','b0','iParam');
	end
end
