function properties = get_all_properties(L)
    img_num = 33;
    properties = zeros([1, 2^(3 * L)]);
    cnt = 0;
    for i = 1 : 1 : img_num
        img = imread(char("../resource/Faces/" + string(i) + ".bmp"));
        property = get_property(img, L);
        properties = properties + property;
        cnt = cnt + 1;
    end
    properties = properties / cnt;
end
