clear all; close all; clc;
load('resource/hall.mat');

test_mat = hall_gray(1:8, 1:8);
C1 = dct2(test_mat - 128);
C2 = dct2(test_mat);
offset = dct2(zeros([8, 8]) + 128);
C2(1, 1) = C2(1, 1) - offset(1, 1);
disp(sum((C1 - C2).^2, 'all'));
