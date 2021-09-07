function Out = freqdom_hide3(In, info)
    info = double(info);
    info(info == 0) = -1;
    Out = zeros(size(In));
    for i = 1 : 1 : size(In, 2)
        this_seq = In(:, i);
        if this_seq == 0
            Out(:, i) = [info(i); In(2 : end, i)];
        else
            not_zero = flipud(this_seq ~= 0);
            this_seq = flipud(this_seq);
            [~, idx] = max(not_zero);
            if idx == 1
                this_seq(1) = info(i);
            else
                this_seq(idx - 1) = info(i);
            end
            Out(:, i) = flipud(this_seq);
        end
    end
end
