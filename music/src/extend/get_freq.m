function freq = get_freq(tunes, idx)
    ratio = 2^(1/12);
    is_int = @(x) x == round(x);
    if is_int(idx)
        freq = tunes(idx);
    else
        freq = tunes(ceil(idx)) * ratio;
    end
end
