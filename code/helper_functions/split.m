function S = split(s,d)
% s: string. d: delimiters. S: split string
	n = numel(s);
	k = 1;
	w = [];
	for i = 1:n
		if (isdelim(s(i)) || ismember(s(i),d)) & ~isempty(w)
			S{k} = w;
			k = k+1;
			w = [];
		elseif isdelim(s(i)) || ismember(s(i),d)
			continue;
		else
			w = [w s(i)];
		end
	end
end

function isDelimiter = isdelim(c)
	isDelimiter = ismember(uint8(c),[0:32 127]);
end
