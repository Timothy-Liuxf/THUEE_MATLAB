clear all; close all; clc;
load('../resource/hall.mat');

[h, w] = size(hall_gray);
test_mat = double(hall_gray) - 128;

C_transpose = blockproc(test_mat, [8, 8], @(blk) dct2_transpose(blk.data));
C_rot90 = blockproc(test_mat, [8, 8], @(blk) dct2_rot90(blk.data));
C_rot180 = blockproc(test_mat, [8, 8], @(blk) dct2_rot180(blk.data));
res_transpose = uint8(blockproc(C_transpose, [8, 8], @(blk) idct2(blk.data)) + 128);
res_rot90 = uint8(blockproc(C_rot90, [8, 8], @(blk) idct2(blk.data)) + 128);
res_rot180 = uint8(blockproc(C_rot180, [8, 8], @(blk) idct2(blk.data)) + 128);

figure(1);
subplot(1, 4, 1);
imshow(hall_gray(81:88, 73:80));
title('Origin');
subplot(1, 4, 2);
imshow(res_transpose(81:88, 73:80));
title('Transpose');
subplot(1, 4, 3);
imshow(res_rot90(81:88, 73:80));
title('Rot 90');
subplot(1, 4, 4);
imshow(res_rot180(81:88, 73:80));
title('Rot 180');

figure(2);
subplot(1, 3, 1);
imshow(res_transpose);
title('Transpose');
subplot(1, 3, 2);
imshow(res_rot90);
title('Right Clear');
subplot(1, 3, 3);
imshow(res_rot180);
title('Left Clear');

function C = dct2_transpose(P)
    C = dct2(P)';
end

function C = dct2_rot90(P)
    C = rot90(dct2(P));
end

function C = dct2_rot180(P)
    C = rot90(dct2(P), 2);
end
