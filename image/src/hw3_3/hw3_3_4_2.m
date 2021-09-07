clear all; close all; clc;
load ../resource/JpegCoeff.mat
load ../resource/hall.mat
addpath ../hw3_2

img2proc = double(hall_gray) - 128;
[img_height, img_width] = size(img2proc);
[~, ~, img2proc] = image_padding(img_height, img_width, 8, 8, img2proc);

C = blockproc(img2proc, [8, 8], @(blk) zig_zag_8(round(dct2(blk.data) ./ QTAB)));
[h, w] = size(C);
hp = h / 64;

C_tilde = zeros([64, hp * w]);
for i = 1 : 1 : hp
    C_tilde(:, (i - 1) * w + 1 : i * w) = C((i - 1) * 64 + 1 : i * 64, 1 : w);
end

info1 = randi([0, 1], size(C_tilde, 1), size(C_tilde, 2));
C_hide1 = freqdom_hide1(C_tilde, info1);
info23 = randi([0, 1], 1, size(C_tilde, 2));
C_hide2 = freqdom_hide2(C_tilde, info23, QTAB);
C_hide3 = freqdom_hide3(C_tilde, info23);

h = img_height;
w = img_width;
hp = h / 8;
wp = w / 8;

dc_stream1 = dc_encode(C_hide1(1, :)', DCTAB);
ac_stream1 = ac_encode(C_hide1(2 : end, :), ACTAB);
dc_cum1 = dc_decode(dc_stream1, hp * wp, DCTAB);
ac_decoding_res1 = ac_decode(ac_stream1, hp * wp, ACTAB);
decoding_res1 = [dc_cum1'; ac_decoding_res1];
find_info1 = freqdom_find1(decoding_res1);
decoding_C1 = zeros(64 * hp, wp);
for i = 1 : 1 : hp
    decoding_C1((i - 1) * 64 + 1 : i * 64, :) = decoding_res1(:, (i - 1) * wp + 1 : i * wp);
end
decoding1 = blockproc(decoding_C1, [64, 1], @(blk) idct2(i_zig_zag_8(blk.data) .* QTAB));
decoding_img1 = uint8(decoding1 + 128);
image_res1 = decoding_img1(1 : img_height, 1 : img_width);

dc_stream2 = dc_encode(C_hide2(1, :)', DCTAB);
ac_stream2 = ac_encode(C_hide2(2 : end, :), ACTAB);
dc_cum2 = dc_decode(dc_stream2, hp * wp, DCTAB);
ac_decoding_res2 = ac_decode(ac_stream2, hp * wp, ACTAB);
decoding_res2 = [dc_cum2'; ac_decoding_res2];
find_info2 = freqdom_find2(decoding_res2, QTAB);
decoding_C2 = zeros(64 * hp, wp);
for i = 1 : 1 : hp
    decoding_C2((i - 1) * 64 + 1 : i * 64, :) = decoding_res2(:, (i - 1) * wp + 1 : i * wp);
end
decoding2 = blockproc(decoding_C2, [64, 1], @(blk) idct2(i_zig_zag_8(blk.data) .* QTAB));
decoding_img2 = uint8(decoding2 + 128);
image_res2 = decoding_img2(1 : img_height, 1 : img_width);

dc_stream3 = dc_encode(C_hide3(1, :)', DCTAB);
ac_stream3 = ac_encode(C_hide3(2 : end, :), ACTAB);
dc_cum3 = dc_decode(dc_stream3, hp * wp, DCTAB);
ac_decoding_res3 = ac_decode(ac_stream3, hp * wp, ACTAB);
decoding_res3 = [dc_cum3'; ac_decoding_res3];
find_info3 = freqdom_find3(decoding_res3);
decoding_C3 = zeros(64 * hp, wp);
for i = 1 : 1 : hp
    decoding_C3((i - 1) * 64 + 1 : i * 64, :) = decoding_res3(:, (i - 1) * wp + 1 : i * wp);
end
decoding3 = blockproc(decoding_C3, [64, 1], @(blk) idct2(i_zig_zag_8(blk.data) .* QTAB));
decoding_img3 = uint8(decoding3 + 128);
image_res3 = decoding_img3(1 : img_height, 1 : img_width);

calculate_ratio = @(dc_stream, ac_stream) (size(hall_gray, 1) * size(hall_gray, 2)) / ((length(dc_stream) + length(ac_stream)) / 8);
ratios = [calculate_ratio(dc_stream1, ac_stream1), calculate_ratio(dc_stream2, ac_stream2), calculate_ratio(dc_stream3, ac_stream3)];
psnrs = [mypsnr(hall_gray, image_res1), mypsnr(hall_gray, image_res2), mypsnr(hall_gray, image_res3)];
accuracies = [sum(info1  == find_info1, 'all') / (size(info1 , 1) * size(info1 , 2)), ...
              sum(info23 == find_info2, 'all') / (size(info23, 1) * size(info23, 2)), ...
              sum(info23 == find_info3, 'all') / (size(info23, 1) * size(info23, 2))];

disp('Compress ratio: ');
disp(ratios);
disp('PSNR: ');
disp(psnrs);
disp('Accuracy: ');
disp(accuracies);

subplot(2, 2, 1);
imshow(hall_gray);
title('Origin');
subplot(2, 2, 2);
imshow(image_res1);
title('Hide 1');
subplot(2, 2, 3);
imshow(image_res2);
title('Hide 2');
subplot(2, 2, 4);
imshow(image_res3);
title('Hide 3');
