clear all, close all, clc;

tunes = zeros([7 4]);
Fs = 8000;
beat_len = 0.47;
ratio = 2^(1/12);

scale_diffs = [-9, -7, -5, -4, -2, 0, 2]';
real_diffs = ratio.^scale_diffs;
base_A = 6;
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
    mid(1), 1; mid(2), 1; mid(3), 1; mid(1), 1; ...    % Liang zhi lao hu
    mid(2), 1; mid(5), 1; mid(5), 1; pause(0), 1; ...
    mid(3), 1; mid(6), 0.5; mid(6), 0.5; mid(6), 1; mid(6), 1; ...    % Xiao tu zi guai guai
    mid(5), 0.5; mid(3), 0.5; mid(5), 1; mid(3), 1; pause(0), 1; ...
    mid(1), 1.5; mid(1), 0.5; mid(1), 1; mid(6), 0.5; mid(6), 0.5; ... % Wo he xiao ya zi
    mid(5), 1; mid(3), 1; mid(5), 1; pause(0), 1; ...
    mid(2), 0.5; mid(2), 1; mid(3), 0.5; mid(3), 0.5; mid(2), 0.5; mid(1), 0.5; mid(3), 0.5; ... % Tong nian shi zui mei
    mid(2), 2; low(5), 0.5; low(6), 0.5; low(7), 0.5; mid(2), 0.5; ...
    mid(1), 1; mid(2), 1; mid(3), 1; mid(1), 1; ... % Xiao luo hao ya
    mid(2), 1; mid(5), 0.5; mid(5), 0.5; mid(5), 1; pause(0), 1; ...
    mid(3), 1; mid(6), 1; mid(6), 1; high(1), 1; ... % Wo qu hai ou
    mid(7), 1; mid(6), 1; mid(5), 1; pause(0), 1; ...
    mid(1), 1.5; mid(1), 0.5; mid(1), 1; mid(6), 1; ... % Bu pa feng yu
    mid(5), 1; mid(5), 1; mid(3), 1; pause(0), 1; ...
    mid(2), 0.5; mid(2), 1; mid(3), 0.5; mid(3), 0.5; mid(2), 0.5; mid(1), 0.5; mid(2), 0.5; ... % Kuai kuai ba ben ling
    mid(1), 2; mid(1), 0.5; mid(2), 0.5; mid(3), 0.5; mid(5), 0.5; ...
    high(1), 1.5; high(1), 0.5; high(1), 0.5; mid(5), 0.5; mid(3), 0.5; high(1), 0.5; ... % Bao bei xing xing
    mid(7), 2; pause(0), 1; pause(0), 0.5; mid(3), 0.5; ...
    mid(6), 1.5; mid(6), 0.5; mid(6), 0.5; mid(5), 0.5; mid(6), 0.5; mid(7), 0.5; ... % Bao bei yue liang
    mid(5), 2; pause(0), 1; pause(0), 1; ...
    mid(3), 1; mid(5), 0.5; mid(5), 0.5; mid(5), 1; high(1), 1; ... % Cheng zhang shi kuai le
    high(2), 1.5; high(2), 0.5; mid(6), 2; ...
    mid(5), 0.5; mid(5), 0.5; mid(5), 0.5; mid(6), 0.5; mid(7), 0.5; mid(6), 0.5; mid(7), 0.5; high(1), 0.5; ... % Yong gan mai kai
    high(2), 3; pause(0), 0.5; mid(5), 0.5; ...
    high(1), 1.5; high(1), 0.5; high(1), 0.5; mid(5), 0.5; mid(3), 0.5; high(1), 0.5; ... % Bao bei ma ma huai li
    mid(7), 2; pause(0), 1; pause(0), 0.5; mid(3), 0.5; ...
    mid(6), 1.5; mid(6), 0.5; mid(6), 0.5; mid(5), 0.5; mid(6), 0.5; mid(7), 0.5; ... % Bao bei ba ba shi ni
    mid(5), 2; pause(0), 1; pause(0), 1; ...
    mid(3), 1; mid(5), 1; mid(5), 1; high(1), 0.5; high(1), 0.5; ... % Ni shi wo men de
    high(2), 0.5; high(2), 0.5; high(2), 1; mid(6), 2; ...
    mid(5), 0.5; mid(5), 0.5; mid(5), 0.5; mid(6), 0.5; mid(7), 0.5; high(1), 0.5; high(1), 0.5; high(2), 0.5; ... % Yong gan mai kai
    high(1), 4];

len = size(song);
len = len(1);
res = [];
[~, padding] = envelope(0);
last_nPadding = 0;
for i = 1 : 1 : len
    f = tunes(song(i, 1));
    time_len = song(i, 2) * beat_len;
    nTime_len = Fs * time_len * padding;
    t = linspace(0, time_len * padding - 1 / Fs, nTime_len)';
    % tmp_res = envelope(t/time_len) .* sin(2 * pi * f * t);
    tmp_res = envelope(t/time_len) .* (sin(2 * pi * f * t) + 0.2 * sin(2 * pi * 2*f * t) + 0.3 * sin(2 * pi * 3*f * t));
    if (last_nPadding == 0)
        res = [res; tmp_res];
    else
        res = [res(1:end-last_nPadding); res(end-last_nPadding)+tmp_res(1:last_nPadding); tmp_res(last_nPadding+1:end)];
    end
    last_nPadding = round(nTime_len - Fs * time_len);
end

sound(1*res, Fs);
