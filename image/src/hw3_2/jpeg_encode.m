function [dc_stream, ac_stream, img_height, img_width] = jpeg_encode(input_img, DCTAB, ACTAB, QTAB)
    img2proc = double(input_img) - 128;
    [img_height, img_width] = size(img2proc);
    [~, ~, img2proc] = image_padding(img_height, img_width, 8, 8, img2proc);
    
    C = blockproc(img2proc, [8, 8], @(blk) zig_zag_8(round(dct2(blk.data) ./ QTAB)));
    [h, w] = size(C);
    hp = h / 64;
    
    C_tilde = zeros([64, hp * w]);
    for i = 1 : 1 : hp
        C_tilde(:, (i - 1) * w + 1 : i * w) = C((i - 1) * 64 + 1 : i * 64, 1 : w);
    end

    dc_stream = dc_encode(C_tilde(1, :)', DCTAB);
    ac_stream = ac_encode(C_tilde(2 : end, :), ACTAB);
end
