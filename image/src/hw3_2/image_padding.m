function [h_res, w_res, image_res] = image_padding(h, w, h_base, w_base, image)
    pad = false;
    if mod(h, h_base) ~= 0
        h_padding = h_base - h;
        img2proc = [img2proc; zeros(h_padding, w)];
        h_res = h + h_padding;
        pad = true;
    else
        h_res = h;
    end
    if mod(w, w_base) ~= 0
        w_padding = w_base - w;
        img2proc = [img2proc, zeros(h, w_padding)];
        w_res = w + w_padding
        pad = true;
    else
        w_res = w;
    end
    if pad == true
        image_res = zeros([h_res, w_res]);
        image_res(1 : h, 1 : w) = image;
    else
        image_res = image;
    end
end
