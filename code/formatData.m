function formatData(fname,sname,is_interval_data,is_simulated_data)
% fname: name of file containing data. First row indicates names of features.
% sname: name of save file
% is_interval_data: boolean indicating whether data is interval data
% is_simulated_data: boolean indicating whether data is simulated.
%
% for (is_interval_data,is_simulated_data) = 
% ...(0,0): data matrix is of form [--------feature_names-----]
%                                  [source_id data class_names]
%
% ...(1,0): feature names have suffix either 'L' or 'U' to indicate whether a lower or upper bound.
%          data matrix is of form [--------feature_names-----]
%                                 [data class_names source_id]
%
% ...(0,1): data matrix is of form [Y X]
% ...(1,1): data matrix is of form [Y X S]

% construct X, Y, and S
if is_simulated_data % assume no nan's
	M = dlmread(fname);
	n = size(M,1);
	if is_interval_data
		p = (size(M,2)-1)/2;
		Y = M(:,1);
		X = M(:,[1:p]+1);
		S = M(:,[1:p]+1+p);
		save(sname,'X','Y','S');
	else
		p = size(M,2)-1;
		Y = M(:,1);
		X = M(:,[1:p]+1);
		save(sname,'X','Y');
	end
else
	if is_interval_data
		formatStarIntervalData(fname,sname);
	else
		formatStarPointData(fname,sname);
	end
end
