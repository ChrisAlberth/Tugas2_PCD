function result = wienerFilter(image, length, tetha, ~, noise_var, NSR)
    [rows, cols, ~] = size(image);

    g = im2double(image);
    G = fft2(g);

    PSF = fspecial('motion', length, tetha);

    H = fft2(PSF, rows, cols);

    if noise_var == 0
        H = conj(H) ./ (abs(H).^2 + NSR);
    else
        est_NSR = noise_var / var(g(:));
        H = conj(H) ./ (abs(H).^2 + est_NSR);
    end

    F = G.*H;
    result = real(ifft2(F));

    result = im2uint8(result);
end