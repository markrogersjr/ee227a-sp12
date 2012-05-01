model = 'path';
fname_prefix = '/home/aa/ugrad/mrogers/ee227a/project/results/RRconvexInterval/path/path_';
sname = '/home/aa/ugrad/mrogers/ee227a/project/results/RRconvexInterval/summary/path';
collectResults(model,fname_prefix,sname);
load(sname);
Lambda = 0:.1:9.9;
figure;plot(Lambda,results);title('model: path, data: RR');xlabel('lambda');ylabel('loss');

model = 'interval';
fname_prefix = '/home/aa/ugrad/mrogers/ee227a/project/results/RRconvexInterval/interval/interval_';
sname = '/home/aa/ugrad/mrogers/ee227a/project/results/RRconvexInterval/summary/interval';
collectResults(model,fname_prefix,sname);
load(sname);
Rho = 0:.1:9.9;
figure;plot(Rho,results);title('model: interval, data: RR');xlabel('rho');ylabel('loss');


