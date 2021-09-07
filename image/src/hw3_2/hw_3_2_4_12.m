clear all; close all; clc;
load('../resource/JpegCoeff.mat');
load('../resource/hall.mat');

QTAB = QTAB / 2;
[dc_stream, ac_stream, img_height, img_width] = jpeg_encode(hall_gray, DCTAB, ACTAB, QTAB);
image_res = jpeg_decode(dc_stream, ac_stream, img_height, img_width, DCTAB, ACTAB, QTAB);
disp("Compress ratio = " + (size(hall_gray, 1) * size(hall_gray, 2)) / ((length(dc_stream) + length(ac_stream)) / 8));
disp("PSNR = " + mypsnr(hall_gray, image_res));

subplot(1, 2, 1);
imshow(hall_gray);
title('Origin');
subplot(1, 2, 2);
imshow(image_res);
title('Decoding');
