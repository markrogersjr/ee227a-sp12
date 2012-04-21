function test2(iParams)
model = 'path';
fname = '/home/aa/ugrad/mrogers/ee227a/project/data/fakeData.mat';
load(fname);
cv_split = .1;
num_cv_splits = 1/cv_split;
random_splits = false;
for i = iParams
	key = i;
	lambda = Params{i}(1);
	rho = Params{i}(2);
	loss = xval(X,Y,S,model,lambda,rho,cv_split,num_cv_splits,random_splits);
	sname = ['/home/aa/ugrad/mrogers/ee227a/project/results/fakeData/' model '_' num2str(i,'%03d')];
	save(sname,'lambda','rho','loss','i');
end
