function C = my_dct2(P)
    [h, w] = size(P);
    C = my_get_dct2_mat(h) * double(P) * my_get_dct2_mat(w)';
end
