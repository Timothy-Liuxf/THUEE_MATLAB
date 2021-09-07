function res = ac_decode(ac_stream, num_of_blocks, ACTAB)
    ZRL = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1];
    EOB = [1, 0, 1, 0];
    ac_decoding_res = zeros([63, num_of_blocks]);
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
    res = ac_decoding_res;
end
