clear all; close all; clc;

load('jpegcodes.mat');
disp((120 * 168) / ((length(dc_stream) + length(ac_stream)) / 8));
