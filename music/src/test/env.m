function A = env(t, len)
    A = -4 ./ (len .* len) .* (t - len ./ 2).^2 + 1;
end
