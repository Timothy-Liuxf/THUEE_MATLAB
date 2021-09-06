clear all; close all; clc;
load('../resource/hall.mat');
load('../resource/JpegCoeff.mat');

img2proc = double(hall_gray) - 128;
C = blockproc(img2proc, [8, 8], @(blk) zig_zag_8(round(dct2(blk.data) ./ QTAB)));
[h, w]  =size(C);
hp = h / 64;
C_tilde = zeros([64, hp * w]);
for i = 1 : 1 : hp
    C_tilde(:, (i - 1) * w + 1 : i * w) = C((i - 1) * 64 + 1 : i * 64, 1 : w);
end

dc = C_tilde(1, :)';
diff_dc = [dc(1); -diff(dc)];
category_plus_one = min(ceil(log2(abs(diff_dc) + 1)), 11) + 1;

dc_stream = arrayfun(@(i) ...
    [DCTAB(category_plus_one(i), 2 : DCTAB(category_plus_one(i), 1) + 1), ...
    dec2bin_array(diff_dc(i))]', ...
    [1 : length(diff_dc)]', 'UniformOutput', false);
dc_stream = cell2mat(dc_stream);

% jpegcodes.mat

function y = dec2bin_array(x)
    if x == 0
        y = [];
    else
        y = double(dec2bin(abs(x))) - '0';
        if x < 0
            y = ~y;
        end
    end
end
