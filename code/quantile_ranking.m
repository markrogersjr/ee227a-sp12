function [X Y S] = quantile_ranking(X,Y,S)

L = (X-S) / 2;
H = (X+S) / 2;
LH = [L;H];
Irandom = randperm(numel(Y));
[R Iinverse] = sort(Irandom);
LH = LH(Irandom,:);
for i = 1:size(LH,2)
	[vals ranks] = sort(LH(:,i));
	LH(:,i) = norminv(ranks / (numel(ranks)+1),0,1);
end
LH = LH(Iinverse,:);
L = LH([1:(size(LH,1)/2)],:);
H = LH([1:(size(LH,1)/2)]+size(LH,1)/2,:);
X = (L+H) / 2;
S = abs(L-H) / 2;


