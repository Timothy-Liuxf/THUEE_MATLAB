function psnr_val = mypsnr(org_img, decoding_img)
    MSE = sum((double(decoding_img) - double(org_img)).^2, 'all') / (size(org_img, 1) * size(org_img, 2));
    psnr_val = 10 * log10(255 * 255 / MSE);
end
