function image_res = jpeg_decode(dc_stream, ac_stream, img_height, img_width, DCTAB, ACTAB, QTAB)
    [h, w, ~] = image_padding(img_height, img_width, 8, 8, zeros(img_height, img_width));
    hp = h / 8;
    wp = w / 8;
    dc_cum = dc_decode(dc_stream, hp * wp, DCTAB);
    ac_decoding_res = ac_decode(ac_stream, hp * wp, ACTAB);
    
    decoding_res = [dc_cum'; ac_decoding_res];
    decoding_C = zeros(64 * hp, wp);
    for i = 1 : 1 : hp
        decoding_C((i - 1) * 64 + 1 : i * 64, :) = decoding_res(:, (i - 1) * wp + 1 : i * wp);
    end
    decoding = blockproc(decoding_C, [64, 1], @(blk) idct2(i_zig_zag_8(blk.data) .* QTAB));
    decoding_img = uint8(decoding + 128);
    image_res = decoding_img(1 : img_height, 1 : img_width);
end
