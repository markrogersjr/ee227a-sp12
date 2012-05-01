function fakeData(n,p)
% require n to be even in order to balance the two classes.  Two standard Gaussians centered approximately at +1 and -1. Decision boundary is 0 and approximately 25% of data is on the wrong side of decision boundary.

if mod(n,2)==1
	error('n must be even in order to balance the two classes.');
end
u1 = .67*ones(p,1);
u2 = .67*ones(p,1);
X = randn(n,p);
X(1:2:n,:) = X(1:2:n,:) + repmat(u1',n/2,1);
X(2:2:n,:) = X(2:2:n,:) - repmat(u2',n/2,1);
Y(1:2:n,1) = ones(n/2,1);
Y(2:2:n,1) = -ones(n/2,1);
S = rand(n,p);
Params = cell(10);
f = @(x) exp(x)-1;
g = @(x) (x-1)/10;
for i = 1:10
	for j = 1:10
		Params{i,j} = [f(g(i)) f(g(j))];
	end
end
save('~/ee227a/project/fakeData','X','Y','S','n','p','Params');
