function result = noiseRemoval(image, noise_type, filter_type)
    noisedImage = noiseImage(image, 0.1);

    denoisedImage = removeNoise(noisedImage, filter_type);

    % figure;
    % subplot(1, 3, 1);
    % imshow(image);
    % title('Gambar Asli');
    
    % subplot(1, 3, 2);
    % imshow(noisyImage);
    % title('Gambar dengan Noise Salt & Pepper');
    
    % subplot(1, 3, 3);
    % imshow(denoisedImage);
    % title(['Gambar Hasil Penghilangan Noise - Filter ' filter_type]);

    result = denoisedImage;
end

function result = noiseImage(image, density)
    result = imnoise(image, 'salt & pepper', density);
end

function result = removeNoise(image, filter_type)
    image = im2double(image);
    padded_image = padarray(image, [1, 1], 'replicate');

    if (size(image, 3) == 3)
        R = removeChannelNoise(padded_image(:, :, 1), filter_type);
        G = removeChannelNoise(padded_image(:, :, 2), filter_type);
        B = removeChannelNoise(padded_image(:, :, 3), filter_type);
        result = cat(3, R, G, B);
    else
        result = removeChannelNoise(padded_image, filter_type);
    end

    result = im2uint8(result);
end

function result = removeChannelNoise(channel, filter_type)
    [rows, cols] = size(channel);
    result = zeros(rows, cols);

    for i = 1:rows-2
        for j = 1:cols-2
            window = channel(i:i+2, j:j+2);

            if filter_type == "min"
                result(i, j) = min(window(:));
            elseif filter_type == "max"
                result(i, j) = max(window(:));
            elseif filter_type == "median"
                result(i, j) = median(window(:));
            elseif filter_type == "arithmetic mean"
                result(i, j) = mean(window(:));
            elseif filter_type == "geometric mean"
                result(i, j) = prod(window(:))^(1/9);
            elseif filter_type == "harmonic mean"
                result(i, j) = 3*3 / sum(1 ./ double(window(:)));
            elseif filter_type == "contraharmonic mean"
                result(i, j) = sum(window(:).^2) / sum(window(:));
            elseif filter_type == "midpoint"
                result(i, j) = (min(window(:)) + max(window(:))) / 2;
            elseif filter_type == "alpha-trimmed mean"
                sorted_window = sort(window(:));
                result(i, j) = mean(sorted_window(3:end-2));
            end
        end
    end
end