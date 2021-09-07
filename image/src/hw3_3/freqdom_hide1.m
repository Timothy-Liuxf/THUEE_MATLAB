function Out = freqdom_hide1(In, info)
    Out = double(bitset(int64(round(In)), 1, info));
end
