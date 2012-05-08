function ranks = mytiedrank(x)

[R I] = sort(x);
[RI II] = sort(I);
ranks = zeros(size(x));
for i = 1:numel(ranks)
	for j = 1:numel(ranks)
		if x(I(II(i)))==x(I(II(j)))
			ranks(i) = ranks(i) + II(j);
		end
	end
	ranks(i) = ranks(i) / numel(find(x == x(I(II(i)))));
end
