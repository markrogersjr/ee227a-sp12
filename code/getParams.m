function getParams(sname,C,Lambda,Rho)
% produces a MAT file containing Params={|Lambda| x |Rho|}, a cell array such that Params{i,j} = [Lambda(i) Rho(j)].  NOte that we cannot allow lambda=inf (or C=0). If passing C only, let Lambda = []. If passing Lambda only, let C = [].
if isempty(Lambda)
	Lambda = sort(1./C);
end
if isempty(C)
	C = sort(1./Lambda);
end
if size(Lambda,2)==1
	Lambda = Lambda';
end
if size(C,2)==1
	Rho = Rho';
end
if size(Rho,2)==1
	C = C';
end
C = sort(C);
Lambda = sort(Lambda);
Rho = sort(Rho);
Params = cell(numel(Lambda),numel(Rho));
for i = 1:numel(Lambda)
	for j = 1:numel(Rho)
		Params{i,j} = [Lambda(i) Rho(j)];
	end
end
save(sname,'Params','C','Lambda','Rho')
