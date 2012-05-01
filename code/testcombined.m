function testcombined(iParams)

fname = '/home/aa/ugrad/mrogers/ee227a/project/data/CEPconvexInterval';
sname = '/home/aa/ugrad/mrogers/ee227a/project/results/CEPconvexInterval/combined/combined';

params_fname = '/home/aa/ugrad/mrogers/ee227a/project/params100.mat';
model = 'path';
for i = iParams
	getResults(fname,sname,params_fname,i,model);
end

