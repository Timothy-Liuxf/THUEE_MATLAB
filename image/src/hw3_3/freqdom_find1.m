function info = freqdom_find1(In)
    info = uint8(bitget(int64(round(In)), 1));
end
