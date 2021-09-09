function [r g b] = val2rgb(val, L)
    r = val / 2^(2 * L);
    val = val - r * 2^(2 * L);
    g = val / 2^L;
    b = val - g * 2^L;
    r = round(double(r) * 2^(8 - L));
    g = round(double(g) * 2^(8 - L));
    b = round(double(b) * 2^(8 - L));
end

