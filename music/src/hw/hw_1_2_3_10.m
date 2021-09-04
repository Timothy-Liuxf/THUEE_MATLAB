clear all, close all, clc;

hw_1_2_2_8;

Fs = 8000;
beat_len = 0.47;
ratio = 2^(1/12);
tunes = get_tunes('F');
low = @(x) x;
mid = @(x) x + 7;
high = @(x) x + 14;
pause = @(x) 22;

song = [...
    mid(5), 1; mid(5), 0.5; mid(6), 0.5; ...
    mid(2), 2; ...
    mid(1), 1; mid(1), 0.5; low(6), 0.5; ...
    mid(2), 2];

res_song = produce(song, tunes, Fs, beat_len, res);
sound(res_song, Fs);
