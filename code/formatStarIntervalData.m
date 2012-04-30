function formatStarIntervalData(fname,sname)

% get n, p, feature_names = {p x 1}
I = 0;
f = fopen(fname,'r');
s = fgetl(f);
C = split(s,';');
feature_names = {};
J = numel(C);
raw_feature_names = C;
for i = 1:J
	feature_name = C{i}(1:(numel(C{i})-1));
	if ~ismember(i,[J-1,J]) && ~ismember(feature_name,feature_names)
		feature_names{numel(feature_names)+1} = feature_name;
	end
end
while ~isequal(s,-1)
	I = I+1;
	s = fgetl(f);
end
fclose(f);
n = I-1;
p = (J-2)/2;

% initialize variables
X = zeros(n,p);
S = zeros(n,p);
Y = zeros(n,1);
class_of_each_datapoint = cell(n,1);
class_names = {};
source_id = zeros(n,1);
L = zeros(n,p);
U = zeros(n,p);
S = zeros(n,p);

% Construct L, H, class = {n x 1}, class_names = {#classes x 1}
f = fopen(fname,'r');
s = fgetl(f);
for i = 1:n
	C = split(fgetl(f),';');
	disp([i,numel(C),J])
	class_of_each_datapoint{i} = C{J-1};
	try,source_id(i) = str2num(C{J});catch err,keyboard;end
	if ~ismember(class_of_each_datapoint{i},class_names)
		class_names{numel(class_names)+1} = class_of_each_datapoint{i};
	end
	for j = 1:(J-2)
		feature_name = raw_feature_names{j}(1:(numel(raw_feature_names{j})-1));
		LorU = raw_feature_names{j}(numel(raw_feature_names{j}));
		num = str2num(C{j});
		if isempty(num)
			num = nan;
		end
		
		% find index and bound (lower or upper) corresponding to current column
		for k = 1:numel(feature_names)
			if strcmp(feature_name,feature_names{k})
				if strcmp(LorU,'L')
					L(i,k) = num;
				elseif strcmp(LorU,'U')
					U(i,k) = num;
				end
			end
		end

	end
end

% Construct X, S, and Y
X = (L+U) ./ 2;
S = abs(L-U) ./ 2;
for i = 1:numel(class_names)
	iClass = find(strcmp(class_of_each_datapoint,class_names{i}));
	Y(iClass) = i*ones(numel(iClass),1);
end

% save data in .mat file
save(sname,'X','Y','S','class_of_each_datapoint','class_names','source_id','feature_names');	
