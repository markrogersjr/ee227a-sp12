function formatData(fname,interval)
% data stored in fname is of the following format: the first row indicates the names of the features. The first column indicates the source_id of each data point. The last column indicates the name of the class.
% remove extension from fname
%
% fname: filename
% interval:  boolean indicating whether data is in interval format
% X = [n x p]: data matrix
% S = [n x p]: confidence intervals
% classes = {#classes x 1}: class names.
% Y = [n x p]: data labels. Each label is an index of the class in classes.
% source_id = {n x 1}: source id of each data point


if strcmp(fname((numel(fname)-3):numel(fname)),'dat')
	fname = fname(1:(numel(fname)-3));
end

% get matrix dimensions
I = 0;
f=fopen([fname '.dat'],'r');
s = fgetl(f);
S = split(s,';');
J = numel(S);
while ~isequal(s,-1)
	I = I+1;
	s = fgetl(f);
end
fclose(f);
n = I;
p = J-2;

% construct data matrix X = [n x p], class = {n x 1}, class_names = {#classes x 1}, source_id = {n x 1}
X = zeros(n,p);
class_names = {};
source_id = cell(n,1);
f = fopen([fname '.dat'],'r');
for i = 1:n
	i
	s = fgetl(f);
	S = split(s,';');
	if ~ismember(S{1},class)
		class{numel(class)+1} = S{1};
	end
	class{i} = S{1};
	source_id{i} = S{J};
	S = S{2:(J-1)};
	for j = 1:p
		if isempty(str2num(S{j}))
			X(i,j) = nan;
		else
			X(i,j) = str2num(S{j});
		end
	end
end

% construct Y
Y = zeros(n,1);
for i = 1:numel(class_names)
	iClass = strcmp(class,class_names{i});
	Y(iClass) = i;
end
save([fname '.mat'],'M');
	
