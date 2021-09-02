function res = produce(song, tunes, Fs, beat_len)

len = size(song);
len = len(1);
res = [];
[~, padding] = envelope(0);
last_nPadding = 0;
ratio = 2^(1/12);

for i = 1 : 1 : len
    f = tunes(song(i, 1));
    time_len = song(i, 2) * beat_len;
    nTime_len = Fs * time_len * padding;
    t = linspace(0, time_len * padding - 1 / Fs, nTime_len)';
    % tmp_res = envelope(t/time_len) .* sin(2 * pi * f * t);
    tmp_res = envelope(t/time_len) .* (sin(2 * pi * f * t) + 0.2 * sin(2 * pi * 2*f * t) + 0.1 * sin(2 * pi * 3*f * t));
    if (last_nPadding == 0)
        res = [res; tmp_res];
    else
        res = [res(1:end-last_nPadding); res(end-last_nPadding)+tmp_res(1:last_nPadding); tmp_res(last_nPadding+1:end)];
    end
    last_nPadding = round(nTime_len - Fs * time_len);
end

end
