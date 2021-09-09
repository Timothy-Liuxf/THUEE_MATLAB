function val = rgb2val(r, g, b, L)
    r = floor(double(r) * 2^(L - 8));
    g = floor(double(g) * 2^(L - 8));
    b = floor(double(b) * 2^(L - 8));
    val = r * 2^(2 * L) + g * 2^(L) + b;
end

