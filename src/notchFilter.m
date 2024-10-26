function result = notchFiltering(image, D0, n, freq_rows, freq_cols)
    if size(image, 3) == 3
        image = rgb2gray(image);
    end

    [rows, cols] = size(image);

    f = im2double(image);
    F = fft2(f);
    F = fftshift(F);
    S2 = log(1 + abs(F));

    figure, imshow(S2, []); title('Fourier spectrum');

    u = 0:(rows-1);
    v = 0:(cols-1);

    idx = find(u > rows/2);
    u(idx) = u(idx) - rows;
    idy = find(v > cols/2);
    v(idy) = v(idy) - cols;

    [V, U] = meshgrid(v, u);

    H = ones(rows, cols);

    for i = 1:size(freq_rows, 1)
        for j = 1:size(freq_cols, 1)
            u_k = freq_rows(i);
            v_k = freq_cols(j);

            D1 = sqrt((U - u_k).^2 + (V - v_k).^2);
            D2 = sqrt((U + u_k).^2 + (V + v_k).^2);

            H(D1 <= D0 | D2 <= D0) = 0;
        end
    end

    H = ifftshift(H);
    HF = H .* F;
    figure;
    imshow(log(1 + abs(HF)), []);
    title('Filtered Fourier Spectrum');

    G = real(ifft2(ifftshift(HF)));
    result = im2uint8(G);
end