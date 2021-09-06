clear all; close all; clc;
load('../resource/hall.mat');

test_mat = double(hall_gray(1:8, 1:8)) - 128;
res_std = dct2(test_mat);
res_test = my_dct2(test_mat);
disp('res_std: ');
disp(res_std);
disp('res_test: ');
disp(res_test);
disp('error: ');
disp(sum((res_std - res_test).^2, 'all'));
