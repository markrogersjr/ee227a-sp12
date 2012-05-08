function [X Y S] = quantile_ranking(X,Y,S)

n = size(X,1);
p = size(X,2);
L = (X-S) / 2;
H = (X+S) / 2;
LH = [L;H];
%Irandom = randperm(2*n);
%[R Iinverse] = sort(Irandom);
%LH = LH(Irandom,:);
for i = 1:p
%	[R I] = sort(LH(:,i));
%	[RI ranks] = sort(I);
	ranks = mytiedrank(LH(:,i));
	LH(:,i) = norminv(ranks / (numel(ranks)+1),0,1);
	license_error_is_thrown = false;
end
%LH = LH(Iinverse,:);
L = LH([1:n],:);
H = LH([1:n]+n,:);
X = (L+H) / 2;
S = (H-L) / 2;
if ~all(S(:) >= 0)
	error('Some lower bounds are exceeding their upper bounds.');
end


