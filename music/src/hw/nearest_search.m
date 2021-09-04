function [val, idx] = nearest_search(list, target, is_sorted_list)
% nearest_search: find the nearest element

if nargin < 3
    is_sorted_list = true;
elseif is_sorted_list == false
    if issorted(list) == false
        list = sort(list);
    end
end

if length(list) == 0
   error('The list is empty!');
end

if length(target) == 0
    val = [];
    idx = [];
else
    idx = zeros(size(target));
    for i = 1 : 1 : length(target)
        [~, idx(i)] = min(abs(list - target(i)));
    end
    val = list(idx);
end
