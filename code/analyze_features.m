function analyze_features(data_fname,results_fname,sname,params_fname,name_of_dataset)

min_loss = inf;
load(fname);
load(params_fname);
load(data_fname);
for i = 1:numel(loss_values)
	if loss_values(i) < min_loss
		lambdaBEST = Params{i}(1);
		rhoBEST = Params{i}(2);
	end
end

[loss b b0] = svm(X,Y,X,Y,lambdaBEST,rhoBEST,S);

[R iSorted] = sort(b);
b = b(iSorted);
feature_namesOLD = feature_names;
feature_names = cell(1,numel(feature_names));
for i = 1:numel(feature_names)
	feature_names{i} = feature_namesOLD{iSorted(i)};
end

f=fopen(sname,'w');
for i = numel(feature_names):-1:1
	fprintf(f,[feature_names{i} ':\t' num2str(b(i),'%.10f') '\n']);
end
fclose(f);
