function res = produce(song, tunes, Fs, beat_len, harm)

len = size(song);
len = len(1);
res = [];
[~, padding] = envelope(0);
last_nPadding = 0;
ratio = 2^(1/12);

for i = 1 : 1 : len
    f = get_freq(tunes, song(i, 1));
    time_len = song(i, 2) * beat_len;
    nTime_len = Fs * time_len * padding;
    t = linspace(0, time_len * padding - 1 / Fs, nTime_len)';
    tmp_res = zeros(size(t));
    for j = 1 : 1 : length(harm)
        tmp_res = tmp_res + harm(j) * sin(2 * pi * j * f * t);
    end
        tmp_res = envelope(t/time_len) .* tmp_res;
    if (last_nPadding == 0)
        res = [res; tmp_res];
    else
        res = [res(1:end-last_nPadding); res(end-last_nPadding)+tmp_res(1:last_nPadding); tmp_res(last_nPadding+1:end)];
    end
    last_nPadding = round(nTime_len - Fs * time_len);
end

end
