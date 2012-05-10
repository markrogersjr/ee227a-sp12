function collectResults(dname,save_dname,params_fname,name_of_dataset)
% collectResults.m does two things:  one, it stores all losses computed by computeResults.m in a matrix and plots them. Second, it stores the L0 values of primal variable b as a function of rho for some optimal lambda.
%
% INPUTS
% dname:  directory where outputs from batch.m are stored
% save_dname: directory to store matrix of loss values, matrix of L0_norm(b) vs. (lambda,rho) values are stored.
% params_fname: name of file where parameters are stored.
% name_of_dataset: name of dataset analyzed, which is used to label plots


if ~strcmp(dname(numel(dname)),'/')
	dname = [dname '/'];
end
if ~strcmp(save_dname(numel(save_dname)),'/')
	save_dname = [save_dname '/'];
end
d = dir([dname '*.mat']);
load(params_fname);

% create matrix of loss values, matrix of L0_norm(b) values
disp('collecting loss values in single matrix')
loss_values = zeros(size(Params));
L0_norm_b = zeros(size(Params));
epsilon = 10e-11;
for i = 1:numel(d)
	load([dname d(i).name]);
	i
	loss_values(i) = loss;
	L0_norm_b(i) = numel(find(abs(b)>epsilon));
end

save([save_dname name_of_dataset '_results.mat'],'loss_values','L0_norm_b','Lambda','Rho','C','feature_names','class_of_each_datapoint');
load([save_dname name_of_dataset '_results.mat']);
if ismember(0,Rho)

	% plot loss vs. lambda
	disp('plotting loss vs. lambda')
	f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
	plot(Lambda,loss_values(:,find(Rho==0)));
	title(['loss vs. lambda of point SVM for ' name_of_dataset]);
	xlabel('lambda');
	ylabel('loss');
	saveas(f,[save_dname name_of_dataset '_point.png']);

	% plot loss vs. C
	disp('plotting loss vs. C')
	f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
	plot(C(find(C ~= inf)),flipud(loss_values(find(C ~= inf),find(Rho==0))));
	title(['loss vs. C of point SVM for ' name_of_dataset]);
	xlabel('C');
	ylabel('loss');
	saveas(f,[save_dname name_of_dataset '_point_C.png']);

end
if ismember(0,Lambda)

	% plot loss vs. rho
	disp('plotting loss vs. rho')
	f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
	plot(Rho,loss_values(find(Lambda==0),:));
	title(['loss vs. rho of interval SVM for ' name_of_dataset]);
	xlabel('rho');
	ylabel('loss');
	saveas(f,[save_dname name_of_dataset '_interval.png']);

end

% surface plot of loss vs. (lambda,rho)
disp('plotting loss vs. (lambda,rho)')
f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
imagesc(Lambda,Rho,loss_values');
set(gca,'YDir','normal');
colorbar;
title(['loss vs. (lambda,rho) of combined SVM for ' name_of_dataset]);
xlabel('lambda');
ylabel('rho');
saveas(f,[save_dname name_of_dataset '_combined.png']);

% surface plot of loss vs. (C,rho)
disp('plotting loss vs. (C,rho)')
f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
imagesc(C(find(C~=inf)),Rho,flipud(loss_values(C ~= inf,:))',[min(loss_values(:)) max(loss_values(:))]);
set(gca,'YDir','normal');
colorbar;
title(['loss vs. (C,rho) of combined SVM for ' name_of_dataset]);
xlabel('C');
ylabel('rho');
saveas(f,[save_dname name_of_dataset '_combined_C.png']);

% separate surface plot of loss vs. (C,rho) for when C=inf
if numel(find(C==inf)) > 0
	disp('plotting loss vs. (C=inf,rho)')
	f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
	imagesc(find(C==inf),Rho,flipud(loss_values(C==inf,:))',[min(loss_values(:)) max(loss_values(:))]);
	set(gca,'YDir','normal');
	colorbar;
	title(['loss vs. (C=inf,rho) of combined SVM for ' name_of_dataset]);
	xlabel('C=inf');
	ylabel('Rho');
	saveas(f,[save_dname name_of_dataset '_combined_C=inf.png']);
end

% surface plot of L0_norm(b) vs. (lambda,rho)
disp('plotting L0_norm(b) vs. (lambda,rho)')
f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
imagesc(Lambda,Rho,L0_norm_b');
set(gca,'YDir','normal');
colorbar;
title(['||beta||_0 vs. (lambda,rho) of combined SVM for ' name_of_dataset]);
xlabel('lambda');
ylabel('rho');
saveas(f,[save_dname name_of_dataset '_L0_surface.png']);

% surface plot of L0_norm(b) vs. (C,rho)
disp('plotting loss vs. (C,rho)')
f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
imagesc(C(find(C~=inf)),Rho,flipud(L0_norm_b(find(C~=inf),:))',[min(L0_norm_b(:)) max(L0_norm_b(:))]);
set(gca,'YDir','normal');
colorbar;
title(['||beta||_0 vs. (C,rho) of combined SVM for ' name_of_dataset]);
xlabel('C');
ylabel('rho');
saveas(f,[save_dname name_of_dataset '_combined_C_L0_surface.png']);

% separate surface plot of L0_norm(b) vs. (C,rho) for when C=inf
if numel(find(C==inf)) > 0
	disp('plotting loss vs. (C=inf,rho)')
	f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
	imagesc(find(C==inf),Rho,flipud(L0_norm_b(C==inf,:))',[min(L0_norm_b(:)) max(L0_norm_b(:))]);
	set(gca,'YDir','normal');
	colorbar;
	title(['||beta||_0 vs. (C=inf,rho) of combined SVM for ' name_of_dataset]);
	xlabel('C=inf');
	ylabel('Rho');
	saveas(f,[save_dname name_of_dataset '_combined_C=inf_L0_surface.png']);
end

% plot L0_norm(b) vs. rho
disp('plotting L0_norm(b) vs. rho')
f=figure('units','normalize','outerposition',[0 0 1 1],'visible','off');
plot(Rho,L0_norm_b(find(Lambda==0),:));
xlabel('rho')
ylabel('||beta||_0');
title(['||beta||_0 vs. rho of interval SVM for ' name_of_dataset]);
saveas(f,[save_dname name_of_dataset '_L0_curve.png']);

