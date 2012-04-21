function collectResults(dname,model,results_filename)
if ~strcmp(dname(numel(dname)),'/')
	dname = [dname '/'];
end
d = dir([dname model '*.mat']);
load(results_filename);
for i = 1:numel(d)
	load([dname d(i).name]);
	len = numel(d(i).name);
	iParam = str2num(d(i).name((len-6):(len-4)));
	results(iParam) = loss;
end
save(results_filename,'results');
