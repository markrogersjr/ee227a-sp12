% features.m is the script used to call the driver function analyze_features.m
name_of_dataset = 'RR2';
subdir_name = 'may9_2';
data_fname = ['/home/aa/ugrad/mrogers/ee227a/project/data/' name_of_dataset 'convexInterval.mat'];
results_fname=  ['/home/aa/ugrad/mrogers/ee227a/project/results/summary/' subdir_name '/' name_of_dataset '_results.mat'];
sname = ['/home/aa/ugrad/mrogers/ee227a/project/results/summary/' subdir_name '/' name_of_dataset '_features.txt'];
params_fname = ['/home/aa/ugrad/mrogers/ee227a/project/params' name_of_dataset '.mat'];
analyze_features(data_fname,results_fname,sname,params_fname,name_of_dataset);
