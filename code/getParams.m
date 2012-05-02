function getParams(sname,Lambda,Rho)

Params = cell(numel(Lambda),numel(Rho));
for i = 1:numel(Lambda)
	for j = 1:numel(Rho)
		Params{i,j} = [Lambda(i) Rho(j)];
	end
end
save(sname,'Params','Lambda','Rho')
