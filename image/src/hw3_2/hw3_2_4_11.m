clear all; close all; clc;
load('jpegcodes.mat');
load('../resource/JpegCoeff.mat');
load('../resource/hall.mat');

% DC Decoding

hp = img_height / 8;
wp = img_width / 8;
dc_decoding_res = zeros([hp * wp, 1]);
i = 1;
cnt = 1;
while i <= length(dc_stream)
    for j = 1 : 1 : size(DCTAB, 1)
        % Omitted overbound judge here!!!

        if DCTAB(j, 2 : DCTAB(j, 1) + 1)' == dc_stream(i : i + DCTAB(j, 1) - 1)
            i = i + DCTAB(j, 1);
            category = j - 1;
            if category ~= 0
                Magnitude = dc_stream(i : i + category - 1);
                if Magnitude(1) == 1
                    dc_decoding_res(cnt) = bin2dec(char(Magnitude' + '0'));
                else
                    dc_decoding_res(cnt) = -bin2dec(char(~Magnitude' + '0'));
                end
            end
            i = i + category;
            break;
        end
    end
    cnt = cnt + 1;
end
dc_cum = cumsum([dc_decoding_res(1); -dc_decoding_res(2:end)]);

% AC decoding

ZRL = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1];
EOB = [1, 0, 1, 0];
ac_decoding_res = zeros([63, hp * wp]);
i = 1;
block_cnt = 1;
inner_block_cnt = 1;
while i < length(ac_stream)
    if i + length(ZRL) - 1 <= length(ac_stream) && sum(~(ac_stream(i : i + length(ZRL) - 1) == ZRL')) == 0
        inner_block_cnt = inner_block_cnt + 16;
        i = i + length(ZRL);
    elseif i + length(EOB) - 1 <= length(ac_stream) && sum(~(ac_stream(i : i + length(EOB) - 1) == EOB')) == 0
        block_cnt = block_cnt + 1;
        inner_block_cnt = 1;
        i = i + length(EOB);
    else
        for j = 1 : 1 : size(ACTAB, 1)
            if i + ACTAB(j, 3) - 1 > length(ac_stream)
                continue;
            end
            if ACTAB(j, 4 : ACTAB(j, 3) + 3) == ac_stream(i : i + ACTAB(j, 3) - 1)'
                inner_block_cnt = inner_block_cnt + ACTAB(j, 1);
                i = i + ACTAB(j, 3);
                Amplitude = ac_stream(i : i + ACTAB(j, 2) - 1);
                if Amplitude(1) == 1
                    ac_decoding_res(inner_block_cnt, block_cnt) = bin2dec(char(Amplitude' + '0'));
                else
                    ac_decoding_res(inner_block_cnt, block_cnt) = -bin2dec(char(~Amplitude' + '0'));
                end
                i = i + ACTAB(j, 2);
                inner_block_cnt = inner_block_cnt + 1;
                break;
            end
        end
    end
end

decoding_res = [dc_cum'; ac_decoding_res];
decoding_C = zeros(64 * hp, wp);
for i = 1 : 1 : hp
    decoding_C((i - 1) * 64 + 1 : i * 64, :) = decoding_res(:, (i - 1) * wp + 1 : i * wp);
end
decoding = blockproc(decoding_C, [64, 1], @(blk) idct2(i_zig_zag_8(blk.data) .* QTAB));
decoding_img = uint8(decoding + 128);

MSE = sum((double(decoding_img) - double(hall_gray)).^2, 'all') / (img_height * img_width);
PSNR = 10 * log10(255 * 255 / MSE);
disp("PSNR = " + PSNR);

subplot(1, 2, 1);
imshow(hall_gray);
title('Origin');
subplot(1, 2, 2);
imshow(decoding_img);
title('Decoding');
