clear all; close all; clc;

A = rand(8, 8);
y = zig_zag_8(A)';
disp(A);
disp(y);
