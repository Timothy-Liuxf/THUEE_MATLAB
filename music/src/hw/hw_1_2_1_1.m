clear all, close all, clc;

tunes = zeros([7 4]);
Fs = 8000;
beat_len = 0.5;
ratio = 2^(1/12);

scale_diffs = [-4, -2, 0, 2, 3, 5, 7]';
real_diffs = ratio.^scale_diffs;
base_A = 3;
tunes(base_A, 1) = 220;
tunes(base_A, 2) = 440;
tunes(base_A, 3) = 880;

for i = 1 : 7
    tunes(i, 1:end) = tunes(base_A, 1:end) .* real_diffs(i);
end

low = @(x) x;
mid = @(x) x + 7;
high = @(x) x + 14;
pause = @(x) 22;

song = [...
    mid(5), 1; mid(5), 0.5; mid(6), 0.5; ...
    mid(2), 2; ...
    mid(1), 1; mid(1), 0.5; low(6), 0.5; ...
    mid(2), 2];

len = size(song);
len = len(1);
res = [];
for i = 1 : 1 : len
    f = tunes(song(i, 1));
    time_len = song(i, 2) * beat_len;
    t = linspace(0, time_len - 1 / Fs, Fs * time_len)';
    tmp_res = sin(2 * pi * f * t);
    res = [res; tmp_res];
end

plot([0 : length(res) - 1] / Fs, res);
sound(res, Fs);
audiowrite('hw_1_2_1_1.wav', res, Fs);
