clear all; close all; clc;
L = 3;
properties = get_all_properties(L);

img = imread('testimg/eesast.bmp');
img = check_face(img, properties, L, 0.55, [5, 5], [8, 8]);
figure(1);
imshow(img);

img = imread('testimg/gls.bmp');
img = check_face(img, properties, L, 0.5, [20, 20], [50, 50]);
figure(2);
imshow(img);
