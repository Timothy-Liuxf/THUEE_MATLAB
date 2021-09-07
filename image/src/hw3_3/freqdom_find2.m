function info = freqdom_find2(In, QTAB)
    [~, min_idx] = min(zig_zag_8(QTAB));
    info = uint8(bitget(int64(round(In(min_idx, :))), 1));
end
