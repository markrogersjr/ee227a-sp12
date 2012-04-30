function C = split(s,d)
% s: string. d: delimiters. C: split string
	k = 1;
	w = [];
	isdelim = @(c) ismember(uint8(c),[0:31 127]) || ismember(c,d);
	while isdelim(s(1))
		s = s(2:numel(s));
	end
	while isdelim(s(numel(s)))
		s = s(1:(numel(s)-1));
	end
	for i = 1:numel(s)
		if ~isdelim(s(i))
			w = [w s(i)];
		else
			C{k} = w;
			w = [];
			k = k+1;
		end
	end
	C{k} = w;
