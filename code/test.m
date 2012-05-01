function test(iParams,model,dataset)

if strcmp(dataset,'RR')
	fname = '/home/aa/ugrad/mrogers/ee227a/project/data/RRconvexInterval';
	sname = '/home/aa/ugrad/mrogers/ee227a/project/results/RRconvexInterval/';
elseif strcmp(dataset,'RR2')
  fname = '/home/aa/ugrad/mrogers/ee227a/project/data/RR2convexInterval';
  sname = '/home/aa/ugrad/mrogers/ee227a/project/results/RR2convexInterval/';
elseif strcmp(dataset,'CEP')
  fname = '/home/aa/ugrad/mrogers/ee227a/project/data/CEPconvexInterval';
  sname = '/home/aa/ugrad/mrogers/ee227a/project/results/CEPconvexInterval/';
end
if strcmp(model,'path')
	params_fname = '/home/aa/ugrad/mrogers/ee227a/project/paramspath.mat';
	sname = [sname 'path/path'];
elseif strcmp(model,'interval')
	params_fname = '/home/aa/ugrad/mrogers/ee227a/project/paramsinterval.mat';
	sname = [sname 'interval/interval'];
elseif strcmp(model,'combined')
	params_fname = '/home/aa/ugrad/mrogers/ee227a/project/paramscombined.mat';
	sname = [sname 'combined/combined'];
end

for i = iParams
	getResults(fname,sname,params_fname,i,model);
end

