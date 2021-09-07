function y = dec2bin_array(x)
    if x == 0
        y = [];
    else
        y = double(dec2bin(abs(x))) - '0';
        if x < 0
            y = ~y;
        end
    end
end
