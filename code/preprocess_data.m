function [X Y S class_of_each_datapoint feature_names] = preprocess_data(X,Y,S,class_of_each_datapoint,feature_names)

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
