function test(iParams)

%fname = '/home/aa/ugrad/mrogers/ee227a/project/data/simulated_interval';
%sname = '/home/aa/ugrad/mrogers/ee227a/project/results/simulated_interval/path/path';
%fname = '/home/aa/ugrad/mrogers/ee227a/project/data/RRconvexPoint';
%sname = '/home/aa/ugrad/mrogers/ee227a/project/results/RRconvexPoint/path/path';
fname = '/home/aa/ugrad/mrogers/ee227a/project/data/RRconvexInterval';
sname = '/home/aa/ugrad/mrogers/ee227a/project/results/RRconvexInterval/combined/combined';



params_fname = '/home/aa/ugrad/mrogers/ee227a/project/params100.mat';
model = 'path';
for i = iParams
	getResults(fname,sname,params_fname,i,model);
end

