function ac_stream = ac_encode(ac, ACTAB)
    Size = min(ceil(log2(abs(ac) + 1)), 10);
    ac_stream = [];
    ZRL = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1];
    EOB = [1, 0, 1, 0];
    for i = 1 : 1 : size(ac, 2)
        this_ac = ac(:, i);
        this_Size = Size(:, i);
        last_not_zero_idx = 0;
        not_zero = this_ac ~= 0;
        while sum(not_zero) ~= 0
            [~, new_idx] = max(not_zero);
            Run = new_idx - last_not_zero_idx - 1;
            num_of_ZRL = floor(Run / 16);
            Run = mod(Run, 16);
            this_tab_row = Run * 10 + this_Size(new_idx);
            ac_stream = [ac_stream, repmat(ZRL, num_of_ZRL, 1), ACTAB(this_tab_row, 4 : ACTAB(this_tab_row, 3) + 3), dec2bin_array(this_ac(new_idx))];
            not_zero(new_idx) = 0;
            last_not_zero_idx = new_idx;
        end
        ac_stream = [ac_stream, EOB];
    end
    ac_stream = ac_stream';
end
