function tunes = get_tunes(major)
    tunes = zeros([7 4]);
    ratio = 2^(1/12);
    
    switch (major)
        case 'C'
            base_A = 6;
        case 'F'
            base_A = 3;
        case { 'A', 'B', 'D', 'E', 'G' }
            
        otherwise
            error('The parameter major is invalid!');
    end

    tunes(base_A, 1) = 220;
    tunes(base_A, 2) = 440;
    tunes(base_A, 3) = 880;
    
    switch base_A
        case 3
            scale_diffs = [-4, -2, 0, 2, 3, 5, 7]';
        case 6
            scale_diffs = [-9, -7, -5, -4, -2, 0, 2]';
        otherwise
            error('Unfinished! Please stay tuned...');
    end
    
    real_diffs = ratio.^scale_diffs;
    
    for i = 1 : 7
        tunes(i, 1:end) = tunes(base_A, 1:end) .* real_diffs(i);
    end
end
