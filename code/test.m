function test(iParams)
% test.m computes the results of applying the SVM interval classifier data in sname.  The results are stored in sname and the parameters are loaded from params_fname. iParams is a vector of indices which indicates which (lambda,rho) pairs of the cell array Params in params_fname to use.  Note that for each index i of iParam, the corresponding save name is sname_prefix_i.mat.

fname = '/home/aa/ugrad/mrogers/ee227a/project/data/RRconvexInterval.mat'; % filename where the data is stored
sname_prefix = '/home/aa/ugrad/mrogers/ee227a/project/results/RRconvexInterval'; % prefix of the filename where the data will be saved
params_fname = '/home/aa/ugrad/mrogers/ee227a/project/params.mat'; % where parameters are saved
for i = iParams
	computeResults(fname,sname_prefix,params_fname,i);
end
