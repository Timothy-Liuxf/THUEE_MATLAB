clear all; close all; clc;
load('jpegcodes.mat');
load('../resource/JpegCoeff.mat');

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
            if category == 0
                dc_decoding_res(cnt) = 0;
            else
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
