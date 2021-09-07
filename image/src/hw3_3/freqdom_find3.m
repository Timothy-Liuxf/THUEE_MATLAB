function info = freqdom_find3(In)
    info = uint8(zeros([1, size(In, 2)]));
    for i = 1 : 1 : size(In, 2)
        this_seq = flipud(In(:, i));
        if this_seq == 0
            info(i) = 0;    % error
            disp('Warning: Get message error: All is zero!');
        else
            is_zero = this_seq ~= 0;
            [~, idx] = max(is_zero);
            if this_seq(idx) == 1
                info(i) = 1;
            elseif this_seq(idx) == -1
                info(i) = 0;
            else
                info(i) = 0;    % error
                disp('Warning: Get message error: Not 1 or -1!');
            end
        end
    end
end
