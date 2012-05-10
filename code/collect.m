% collect.m is the script used to call the driver function collectResults.m
name_of_dataset = 'RR2';
subdir_name = 'may9_2';
dname = ['/home/aa/ugrad/mrogers/ee227a/project/results/' name_of_dataset 'convexInterval/']; % name of directory where results, i.e., outputs from batch.m, are stored. not to be confused with the directory where summary results are stored.
save_dname = ['/home/aa/ugrad/mrogers/ee227a/project/results/summary/' subdir_name '/']; % name of directory where summary results are stored.
params_fname = ['~/ee227a/project/params' name_of_dataset '.mat']; % name of file containing Params cell array, Lambda, Rho, and C
collectResults(dname,save_dname,params_fname,name_of_dataset);
