clear all; close all; clc;
a = [1];
b = [-1, 1];
figure(1);
zplane(b, a);
figure(2);
freqz(b, a);
