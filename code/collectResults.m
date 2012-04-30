function collectResults(fname_prefix,sname)
if strcmp(fname_prefix(numel(fname_prefix)),'/')
	fname_prefix = fname_prefix(1:(numel(fname_prefix)-1));
end
d = dir([fname_prefix '*.mat']);
dname = fname_prefix;
while ~strcmp(dname(numel(dname)),'/')
	dname = dname(1:(numel(dname)-1));
end
results = zeros(100);
save(sname,'results');
load(sname); % has results variable in it, a table of loss values
for i = 1:numel(d)
	load([dname d(i).name]);
	iParam
	results(iParam) = loss;
end
save(sname,'results');
