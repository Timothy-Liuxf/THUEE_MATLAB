clear all; close all; clc;
load('../resource/hall.mat');

[h, w] = size(hall_gray);
test_mat = double(hall_gray) - 128;

C1 = blockproc(test_mat, [8, 8], @(blk) dct2_clear_right(blk.data));
C2 = blockproc(test_mat, [8, 8], @(blk) dct2_clear_left(blk.data));
res1 = uint8(blockproc(C1, [8, 8], @(blk) idct2(blk.data)) + 128);
res2 = uint8(blockproc(C2, [8, 8], @(blk) idct2(blk.data)) + 128);

figure(1);
subplot(1, 3, 1);
imshow(hall_gray);
title('Origin');
subplot(1, 3, 2);
imshow(res1);
title('Right Clear');
subplot(1, 3, 3);
imshow(res2);
title('Left Clear');
%{
imwrite(hall_gray, 'hw3_2_4_3_org.bmp');
imwrite(res1, 'hw3_2_4_3_cr.bmp');
imwrite(res2, 'hw3_2_4_3_cl.bmp');
%}

figure(2);
subplot(1, 3, 1);
imshow(hall_gray(81:88, 73:80));
title('Origin');
subplot(1, 3, 2);
imshow(res1(81:88, 73:80));
title('Right Clear');
subplot(1, 3, 3);
imshow(res2(81:88, 73:80));
title('Left Clear');

function C = dct2_clear_right(P)
    C = dct2(P);
    C(:, 5:8) = 0;
end

function C = dct2_clear_left(P)
    C = dct2(P);
    C(:, 1:4) = 0;
end
