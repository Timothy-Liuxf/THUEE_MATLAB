function property = get_property(img, L)
    [h, w, ~] = size(img);
    img = reshape(img, h * w, 3);
    property = zeros([1, 2^(3 * L)]);
    for j = 1 : 1 : h * w
         val = rgb2val(img(j, 1), img(j, 2), img(j, 3), L);
         property(val + 1) = property(val + 1) + 1;
    end
    property = property / (h * w);
end
