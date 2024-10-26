function result = noiseRemoval(image, filter_type)
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

            if filter_type == "Minimum"
                result(i, j) = min(window(:));
            elseif filter_type == "Maximum"
                result(i, j) = max(window(:));
            elseif filter_type == "Median"
                result(i, j) = median(window(:));
            elseif filter_type == "Arithmetic Mean"
                result(i, j) = mean(window(:));
            elseif filter_type == "Geometric Mean"
                result(i, j) = prod(window(:))^(1/9);
            elseif filter_type == "Harmonic Mean"
                result(i, j) = 3*3 / sum(1 ./ double(window(:)));
            elseif filter_type == "Contraharmonic Mean"
                result(i, j) = sum(window(:).^2) / sum(window(:));
            elseif filter_type == "Midpoint"
                result(i, j) = (min(window(:)) + max(window(:))) / 2;
            elseif filter_type == "Alpha-trimmed Mean"
                sorted_window = sort(window(:));
                result(i, j) = mean(sorted_window(3:end-2));
            end
        end
    end
end