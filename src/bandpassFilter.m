function result = bandpassFilter(image, type, D0, W, n)
    if size(image, 3) == 3
        image = rgb2gray(image);
    end

    [rows, cols] = size(image);

    f = im2double(image);
    F = fft2(f);
    F = fftshift(F);
    disp(size(F));
    S2 = log(1 + abs(F));

    figure, imshow(S2, []); title('Fourier spectrum');

    u = 0:(rows-1);
    v = 0:(cols-1);

    idx = find(u > rows/2);
    u(idx) = u(idx) - rows;
    idy = find(v > cols/2);
    v(idy) = v(idy) - cols;

    [V, U] = meshgrid(v, u);
    D = sqrt(U.^2 + V.^2);

    if strcmp(type, "ideal")
        H = zeros(rows, cols);
        H(D >= (D0 - W/2) & D <= (D0 + W/2)) = 1;
    elseif strcmp(type, "butterworth")
        H = 1 - (1 ./ (1 + ((D * W) ./ (D.^2 - D0^2)).^(2 * n)));
    elseif strcmp(type, "gaussian")
        H = exp(-((D.^2 - D0^2) ./ (D * W + eps)).^2);
    end

    H = ifftshift(H);
    HF = H .* F;
    figure;
    imshow(log(1 + abs(HF)), []);
    title('Filtered Fourier Spectrum');

    G = real(ifft2(HF));
    result = im2uint8(G);
end