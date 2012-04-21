function formatData2(fname)

% remove extension from fname
if strcmp(fname((numel(fname)-3):numel(fname)),'dat')
	fname = fname(1:(numel(fname)-3));
end

% construct data matrix
load([fname '.mat']);
X = X(:,2:(size(X,2)-1));

% construct data labels
X = 
