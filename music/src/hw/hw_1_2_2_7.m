clear all, close all, clc;
load('resource/Guitar.MAT');

cont = resample(realwave, 100, 1);

group_len = round(length(cont) / 10);
res = zeros([group_len, 1]);
for i = 1 : 1 : 10
    res = res + cont((i - 1) * group_len + 1 : i * group_len);
end
res = res / 10;
res = [res; res];
res = [res; res; res; res; res];
res = resample(res, 1, 100);

subplot(3, 1, 1);
plot([0 : length(realwave)-1] / 8000, realwave);
title('realwave');
subplot(3, 1, 2);
plot([0 : length(wave2proc)-1] / 8000, wave2proc);
title('wave2proc');
subplot(3, 1, 3);
plot([0 : length(res)-1] / 8000, res);
title('result');
