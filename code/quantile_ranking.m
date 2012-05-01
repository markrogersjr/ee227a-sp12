function [X Y S] = quantile_ranking(X,Y,S)

n = size(X,1);
p = size(X,2);
L = (X-S) / 2;
H = (X+S) / 2;
LH = [L;H];
Irandom = randperm(2*n);
[R Iinverse] = sort(Irandom);
LH = LH(Irandom,:);
for i = 1:p
	[vals ranks] = sort(LH(:,i));
	LH(:,i) = norminv(ranks / (numel(ranks)+1),0,1);
end
LH = LH(Iinverse,:);
L = LH([1:n],:);
H = LH([1:n]+n,:);
X = (L+H) / 2;
S = abs(L-H) / 2;


