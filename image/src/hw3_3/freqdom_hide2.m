function Out = freqdom_hide2(In, info, QTAB)
    [~, min_idx] = min(zig_zag_8(QTAB));
    In(min_idx, :) = double(bitset(int64(round(In(min_idx, :))), 1, info));
    Out = In;
end
