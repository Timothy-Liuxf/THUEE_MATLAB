clear all; close all; clc;
load('../resource/hall.mat');
load('../resource/JpegCoeff.mat');

hall_gray = hall_gray(1:24, 1:16);
img2proc = double(hall_gray) - 128;
C = blockproc(img2proc, [8, 8], @(blk) zig_zag_8(round(dct2(blk.data) ./ QTAB)));
[h, w]  =size(C);
hp = h / 64;
res = zeros([64, hp * w]);
for i = 1 : 1 : hp
    res(:, (i - 1) * w + 1 : i * w) = C((i - 1) * 64 + 1 : i * 64, 1 : w);
end
