function tunes = get_tunes(major)
    tunes = zeros([7 4]);
    ratio = 2^(1/12);
    
    switch (major)
        case 'A'
            base_A = 1;
        case 'B'
            base_A = 7;
        case 'C'
            base_A = 6;
        case 'D'
            base_A = 5;
        case 'E'
            base_A = 4;
        case 'F'
            base_A = 3;
        case 'G'
            base_A = 2;
        otherwise
            error('Error: The parameter major is invalid!');
    end

    tunes(base_A, 1) = 220;
    tunes(base_A, 2) = 440;
    tunes(base_A, 3) = 880;
    
    switch base_A
        case 2
            scale_diffs = [-2, 0, 2, 3, 5, 7, 8]';
        case 3
            scale_diffs = [-4, -2, 0, 2, 3, 5, 7]';
        case 4
            scale_diffs = [-5, -4, -2, 0, 2, 3, 5]';
        case 5
            scale_diffs = [-7, -5, -4, -2, 0, 2, 3]';
        case 6
            scale_diffs = [-9, -7, -5, -4, -2, 0, 2]';
        case 7
            scale_diffs = [-10, -9, -7, -5, -4, -2, 0]';
        case 1
            base_A = 1;
            tunes = tunes / 2;
            scale_diffs = [0, 2, 3, 5, 7, 8, 10]';
        otherwise
            error('Error: Unknown error!');
    end
    
    real_diffs = ratio.^scale_diffs;
    
    for i = 1 : 7
        tunes(i, 1:end) = tunes(base_A, 1:end) .* real_diffs(i);
    end
end
