clear all; close all; clc;
load('../resource/JpegCoeff.mat');
load('../resource/snow.mat');

[dc_stream, ac_stream, img_height, img_width] = jpeg_encode(snow, DCTAB, ACTAB, QTAB);
image_res = jpeg_decode(dc_stream, ac_stream, img_height, img_width, DCTAB, ACTAB, QTAB);
disp("Compress ratio = " + (size(snow, 1) * size(snow, 2)) / ((length(dc_stream) + length(ac_stream)) / 8));
disp("PSNR = " + mypsnr(snow, image_res));

subplot(1, 2, 1);
imshow(snow);
title('Origin');
subplot(1, 2, 2);
imshow(image_res);
title('Decoding');
