clear all; close all; clc;
L = 3;
properties = get_all_properties(L);
subplot(3, 1, 1);
plot([0 : 1 : 2^(3 * L) - 1], properties);
title('{\itL}=3');

L = 4;
properties = get_all_properties(L);
subplot(3, 1, 2);
plot([0 : 1 : 2^(3 * L) - 1], properties);
title('{\itL}=4');

L = 5;
properties = get_all_properties(L);
subplot(3, 1, 3);
plot([0 : 1 : 2^(3 * L) - 1], properties);
title('{\itL}=5');
