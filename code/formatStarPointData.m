function formatStarPointData(fname,sname)

% get n, p, feature_names = {p x 1}
I = 0;
f = fopen(fname,'r');
s = fgetl(f);
C = split(s,';');
J = numel(C);
feature_names = C{2:(J-1)};
while ~isequal(s,-1)
	I = I+1;
	s = fgetl(f);
end
fclose(f);
n = I-1;
p = J-2;

% initialize variables
X = zeros(n,p);
Y = zeros(n,1);
class = cell(n,1);
class_names = {};
source_id = zeros(n,1);

% construct X, class = {n x 1}, class_names = {#classes x 1}, source_id = [n x 1]
f = fopen(fname,'r');
s = fgetl(f);
for i = 1:n
	i
	C = split(fgetl(f),';');
	source_id(i) = str2num(C{1});
	class_of_each_datapoint{i} = C{J};
	if ~ismember(class_of_each_datapoint{i},class_names)
		class_names{numel(class_names)+1} = class_of_each_datapoint{i};
	end
	for j = 0:(p+1)
		num = str2num(C{j+1});
		if isempty(num)
			num = nan;
		end
		if ismember(j,1:p)
			X(i,j) = num;
		end
	end
end

% construct Y
for i = 1:numel(class_names)
	iClass = find(strcmp(class_of_each_datapoint,class_names{i}))
	Y(iClass) = i*ones(numel(iClass),1);
end

% save data in .mat file
save(sname,'X','Y','class_of_each_datapoint','class_names','source_id','feature_names');
