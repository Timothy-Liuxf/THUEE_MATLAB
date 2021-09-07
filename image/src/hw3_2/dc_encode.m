function dc_stream = dc_encode(dc, DCTAB)
    diff_dc = [dc(1); -diff(dc)];
    category_plus_one = min(ceil(log2(abs(diff_dc) + 1)), 11) + 1;

    dc_stream = arrayfun(@(i) ...
        [DCTAB(category_plus_one(i), 2 : DCTAB(category_plus_one(i), 1) + 1), ...
        dec2bin_array(diff_dc(i))]', ...
        [1 : length(diff_dc)]', 'UniformOutput', false);
    dc_stream = cell2mat(dc_stream);
end
