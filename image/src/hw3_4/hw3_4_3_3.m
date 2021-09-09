clear all; close all; clc;
img_org = imread('testimg/eesast.bmp');

enable1 = true;
enable2 = true;
enable3 = true;

if enable1
    img = img_org;
    img = rot90(img, 3);
    L = 4;
    properties = get_all_properties(L);
    img = check_face(img, properties, L, 0.685, [2, 4], [10, 8]);
    figure(1);
    imshow(img);
end

if enable2
    [h w ~] = size(img_org);
    img = uint8(zeros(h, 2 * w - 1, 3));
    n = mod([1 : 1 : 2 * w - 1], 2) == 1;
    img(:, n, :) = img_org;
    img(:, ~n, :) = uint8((double(img(:, [n(1:end-1), false], :)) + double(img(:, [false, n(2:end)], :))) / 2);
    L = 4;
    properties = get_all_properties(L);
    img = check_face(img, properties, L, 0.685, [2, 4], [10, 8]);
    figure(2);
    imshow(img);
end

if enable3
   figure(3);
   L = 4;
   properties = get_all_properties(L);
   
   img = imread('testimg/eesast_changelight.bmp');
   img = check_face(img, properties, L, 0.685, [2, 4], [10, 8]);
   subplot(2, 1, 1);
   imshow(img);
   
   img = imread('testimg/eesast_changedark.bmp');
   img = check_face(img, properties, L, 0.685, [2, 4], [10, 8]);
   subplot(2, 1, 2);
   imshow(img);
end
