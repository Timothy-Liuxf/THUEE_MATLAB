clear all, close all, clc;
load('resource/Guitar.MAT');

x = wave2proc;

subplot(3, 1, 1);
X1 = fft(x(1:round(end/10)));
plot([0 : length(X1) - 1], abs(X1));

subplot(3, 1, 2);
X2 = fft(x);
plot([0 : length(X2) - 1], abs(X2));

subplot(3, 1, 3);
loop_time = 5;
for i = 1 : 1 : loop_time
    x = [x; x];
end
X3 = fft(x);
plot([0 : length(X3) - 1], abs(X3));

delta = 10 * 2^loop_time;
n = [0 : length(X3) - 1];
res = abs(X3(mod(n, delta) == 0));
res = res / res(2);
disp([[0 : length(res) - 1]', res]);
