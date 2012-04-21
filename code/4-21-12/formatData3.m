function formatData3(fname,interval)

% remove extension from fname
if strcmp(fname((numel(fname)-3):numel(fname)),'dat')
  fname = fname(1:(numel(fname)-3));
end

load([fname '.dat']);
I = 0;
f=fopen([fname '.dat'],'r');
s = fgetl(f);
S = split(s,';');
J = numel(S);
while ~isequal(s,-1)
	I = I+1;
	s = fgetl(f);
end
fclose(f);
n = I;
p = (J-1)/2;

M = zeros(I,J);
X = zeros(n,p);
Y = zeros(n,1);
S = zeros(n,p);
f = fopen([fname '.dat'],'r');
for i = 1:n
	disp(['data point: ' num2str(i)])
	s = fgetl(f);
	S = split(s,';');
	for j = 1:J
		num = str2num(S{j});
		if isempty(num)
			M(i,j) = nan;
		else
			M(i,j) = num;
		end
	end
end
Y = M(:,1);
X = M(:,[1:p]+1);
nanX = isnan(X);
nanS = isnan(S);
for j = 1:p
	X(nanX(:,j),j) = repmat(median(X(~nanX(:,j),j)),sum(nanX(:,j)),1);
end
for j = 1:p
	S(nanS(:,j),j) = repmat(median(S(~nanS(:,j),j)),sum(nanS(:,j)),1);
end
S = M(:,[1:p]+p+1);
save([fname '.mat'],'Y','X','S');
