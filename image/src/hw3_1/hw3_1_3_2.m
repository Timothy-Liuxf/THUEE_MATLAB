clear all; close all; clc;
load('../resource/hall.mat');

[h, w, ~] = size(hall_color);
row_idxs = zeros([h, w]) + [1 : h]';
col_idxs = zeros([h, w]) + [1 : w];

circle = hall_color;
dist = (row_idxs - (h+1)/2).^2 + (col_idxs - (w+1)/2).^2;
radius = min(h/2, w/2)^2;
is_in_circle = dist <= radius & dist > 0.95 * radius;
draw_r_circle = cat(3, is_in_circle, logical(zeros(size(is_in_circle))), logical(zeros(size(is_in_circle))));
draw_gb_circle = cat(3, logical(zeros(size(is_in_circle))), is_in_circle, is_in_circle);
circle(draw_r_circle) = uint8(255);
circle(draw_gb_circle) = uint8(0);
subplot(1, 2, 1);
imshow(circle);
imwrite(circle, 'hw3_1_3_2_circle.bmp');

chess_board = hall_color;
is_black = xor(mod(floor((row_idxs - 1) / 10), 2) == 0, mod(floor((col_idxs - 1) / 10), 2) == 1);
draw_board = cat(3, is_black, is_black, is_black);
chess_board(draw_board) = 0;
subplot(1, 2, 2);
imshow(chess_board);
imwrite(chess_board, 'hw3_1_3_2_chess_board.bmp');
