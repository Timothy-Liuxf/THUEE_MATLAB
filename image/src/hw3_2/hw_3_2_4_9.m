clear all; close all; clc;
load('../resource/hall.mat');
load('../resource/JpegCoeff.mat');

img2proc = double(hall_gray) - 128;
C = blockproc(img2proc, [8, 8], @(blk) zig_zag_8(round(dct2(blk.data) ./ QTAB)));
[h, w] = size(C);
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

ac = C_tilde(2 : end, :);
Size = min(ceil(log2(abs(ac) + 1)), 10);
ac_stream = [];
ZRL = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1];
EOB = [1, 0, 1, 0];
for i = 1 : 1 : size(ac, 2)
    this_ac = ac(:, i);
    this_Size = Size(:, i);
    last_not_zero_idx = 0;
    not_zero = this_ac ~= 0;
    while sum(not_zero) ~= 0
        [~, new_idx] = max(not_zero);
        Run = new_idx - last_not_zero_idx - 1;
        num_of_ZRL = floor(Run / 16);
        Run = mod(Run, 16);
        this_tab_row = Run * 10 + this_Size(new_idx);
        ac_stream = [ac_stream, repmat(ZRL, num_of_ZRL, 1), ACTAB(this_tab_row, 4 : ACTAB(this_tab_row, 3) + 3), dec2bin_array(this_ac(new_idx))];
        not_zero(new_idx) = 0;
        last_not_zero_idx = new_idx;
    end
    ac_stream = [ac_stream, EOB];
end
ac_stream = ac_stream';

img_height = size(hall_gray, 1);
img_width = size(hall_gray, 2);
save('jpegcodes.mat', 'dc_stream', 'ac_stream', 'img_height', 'img_width');

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
