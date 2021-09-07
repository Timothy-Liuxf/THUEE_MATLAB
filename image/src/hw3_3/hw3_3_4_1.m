clear all; close all; clc;
load ../resource/JpegCoeff.mat
load ../resource/hall.mat
addpath ../hw3_2

test_time = 10;
[h, w] = size(hall_gray);
correct_ratio = zeros([test_time, 1]);
for i = 1 : 1 : test_time
    seq = uint8(randi([0, 1], h, w));
    % seq = uint8(ones([h, w]));
    % seq = uint8(zeros([h, w]));
    secret_image = bitset(hall_gray, 1, seq);
    [dc, ac, imh, imw] = jpeg_encode(secret_image, DCTAB, ACTAB, QTAB);
    decoding_image = jpeg_decode(dc, ac, imh, imw, DCTAB, ACTAB, QTAB);
    decoding_seq = bitand(decoding_image, uint8(ones([h, w])));
    correct_seq = ~xor(seq, decoding_seq);
    correct_ratio(i) = sum(correct_seq, 'all') / (h * w);
end

disp("Ratio: ");
disp(correct_ratio');
disp("Average: " + mean(correct_ratio));
