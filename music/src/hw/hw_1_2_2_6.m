clear all, close all, clc;
load('resource/Guitar.MAT');

figure(1);
subplot(2, 1, 1);
t1 = linspace(0, length(realwave) / 8000 - 1/8000, length(realwave));
plot(t1, realwave);
title('realwave');
xlabel('{\itt}/s');
ylabel('{\itA}');

subplot(2, 1, 2);
t2 = linspace(0, length(wave2proc) / 8000 - 1/8000, length(wave2proc));
plot(t2, wave2proc);
title('wave2proc');
xlabel('{\itt}/s');
ylabel('{\itA}');

% sound(realwave, 8000);
% sound(wave2proc, 8000);

[fmt, Fs] = audioread('resource/fmt.wav');
figure(2);
t = linspace(0, length(fmt) / Fs - 1/Fs, length(fmt));
plot(t, fmt);
title('fmt');
xlabel('{\itt}/s');
ylabel('{\itA}');
sound(fmt, Fs);
