u1 = 2*ones(100,1) + (randn(100,1) - .5)/4;
u2 = 2*ones(100,1) + (randn(100,1) - .5)/4;
X = randn(100,1000);
X(:,1:500) = X(:,1:500) + repmat(u1,1,500);
X(:,501:1000) = X(:,501:1000) - repmat(u2,1,500);
X = X';
Y = [ones(500,1);(-1)*ones(500,1)];
n = size(X,1);
p = size(X,2);


models = {'path','interval','combined'};
L = cell(numel(models),1);
Lambda = 0:.01:1;
Rho = 0:.01:1;
for i = 1:numel(models)
	model = models{i};
	L{i} = loo_cv(X,Y,Sigma,model,Lambda,Rho);
	figure;
	imagesc(L{i});
	colormap(gray);
	colorbar;
	xlabel('rho');
	ylabel('lambda');
	title(['Loss for model ' model]);
end
