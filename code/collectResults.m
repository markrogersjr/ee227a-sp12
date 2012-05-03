function collectResults(fname_prefix,sname,params_fname,name_of_dataset)
% collectResults.m stores all losses computed by computeResults.m in a matrix and plots them.
%
% INPUTS
% fname_prefix: filename prefix.  All result files are of the form fname_prefix_index.mat
% sname[DO NOT GIVE AN EXTENSION]: file to store matrix of results.  also the name of the plot files.
% params_fname: name of file where parameters are stored.
% name_of_dataset: name of dataset analyzed, which is used to label plots


% do not give sname an extension.
if strcmp(fname_prefix(numel(fname_prefix)),'/')
	fname_prefix = fname_prefix(1:(numel(fname_prefix)-1));
end
d = dir([fname_prefix '*.mat']);
dname = fname_prefix;
while ~strcmp(dname(numel(dname)),'/')
	dname = dname(1:(numel(dname)-1));
end
load(params_fname);
results = zeros(size(Params));
for i = 1:numel(d)
	load([dname d(i).name]);
	iParam
	results(iParam) = loss;
end
save([sname '.mat'],'results','Lambda','Rho');
if ismember(0,Rho)
	i = find(Rho==0);
	f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
	plot(Lambda,results(:,i));
	title(['standard SVM applied to ' name_of_dataset]);
	xlabel('lambda');
	ylabel('loss');
	saveas(f,[sname '_' name_of_dataset '_standard.png']);
end
if ismember(0,Lambda)
	i = find(Lambda==0);
	f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
	plot(Rho,results(:,i));
	title(['interval SVM applied to ' name_of_dataset]);
	xlabel('rho');
	ylabel('loss');
	saveas(f,[sname '_' name_of_dataset '_interval.png']);
end
f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
imagesc(Lambda,Rho,results);
colorbar;
title(['combined SVM applied to ' name_of_dataset]);
xlabel('rho');
ylabel('lambda');
saveas(f,[sname '_' name_of_dataset '_combined.png']);

	
