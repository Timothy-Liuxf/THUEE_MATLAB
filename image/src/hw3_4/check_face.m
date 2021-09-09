function img_res = check_face(img, properties, L, K, strike, test_size)
    [h w ~] = size(img);
    h_strike = strike(1);
    w_strike = strike(2);
    h_test = test_size(1);
    w_test = test_size(2);
    h_num = floor((h - h_test) / h_strike + 1);
    w_num = floor((w - w_test) / w_strike + 1);
    total_num = h_num * w_num;
    find_top = [];
    find_left = [];
    find_bottom = [];
    find_right = [];
    errs = [];
    find_cnt = 0;
    for i = 1 : h_strike : h - h_test + 1
        for j = 1 : w_strike : w - w_test + 1
            test_img = img(i : i + h_test - 1, j : j + w_test - 1, :);
            this_prop = get_property(test_img, L);
            err = 1 - sum(sqrt(this_prop) .* sqrt(properties));
            if err < K
                find_cnt = find_cnt + 1;
                find_top(find_cnt) = i;
                find_bottom(find_cnt) = i + h_test - 1;
                find_left(find_cnt) = j;
                find_right(find_cnt) = j + w_test - 1;
            end
        end
    end

    illegal_mat = logical(zeros([h w]));
    row_idxs = zeros([h, w]) + [1 : h]';
    col_idxs = zeros([h, w]) + [1 : w];
    for i = 1 : 1 : find_cnt
        this_mat = (row_idxs >= find_top(i) & row_idxs <= find_bottom(i)) ...
                 & (col_idxs >= find_left(i) & col_idxs <= find_right(i));
        illegal_mat = this_mat | illegal_mat;
    end

    [labs, n] = bwlabel(illegal_mat);
    min_left = zeros(n, 1) + w;
    min_top = zeros(n, 1) + h;
    max_right = zeros(n, 1);
    max_bottom = zeros(n, 1);

    for i = 1 : 1 : find_cnt
        lab = labs(find_top(i), find_left(i));
        min_left(lab) = min(min_left(lab), find_left(i));
        min_top(lab) = min(min_top(lab), find_top(i));
        max_right(lab) = max(max_right(lab), find_right(i));
        max_bottom(lab) = max(max_bottom(lab), find_bottom(i));
    end

    edge_weight = round(min(max(max_right - min_left), max(max_bottom - min_top)) * 0.05);
    draw_mat = logical(zeros(size(img)));
    for i = 1 : 1 : n
        draw_mat(min_top(i) : max_bottom(i), min_left(i) : min_left(i) + edge_weight) = true;
        draw_mat(min_top(i) : min_top(i) + edge_weight, min_left(i) : max_right(i)) = true;
        draw_mat(min_top(i) : max_bottom(i), max(1, max_right(i) - edge_weight) : max_right(i)) = true;
        draw_mat(max(1, max_bottom(i) - edge_weight) : max_bottom(i), min_left(i) : max_right(i)) = true;
    end
    draw_r = cat(3, draw_mat, logical(zeros(size(draw_mat))), logical(zeros(size(draw_mat))));
    img(draw_r) = uint8(255);
    img_res = img;
end

