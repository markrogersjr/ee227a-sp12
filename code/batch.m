tic
name_of_dataset = 'RR2';
fname = ['/home/aa/ugrad/mrogers/ee227a/project/data/' name_of_dataset 'convexInterval.mat']; % filename where the data is stored
save_dname = ['/home/aa/ugrad/mrogers/ee227a/project/results/' name_of_dataset 'convexInterval/']; % directory where results are saved
params_fname = ['/home/aa/ugrad/mrogers/ee227a/project/params' name_of_dataset '.mat']; % where parameters are saved
load(params_fname);
num_processes = numel(C)*numel(Rho);
num_batches = ceil(num_processes / 100);
iBatch = input(['Please enter index of batch (1 through ' num2str(num_batches) '): ']);
if iBatch == num_batches && mod(num_processes,100)~=0
	iParams = [1:mod(num_processes,100)] + 100*(iBatch-1);
else
	iParams = [1:100] + 100*(iBatch-1);
end
computeResults(iParams,fname,save_dname,params_fname);
toc
