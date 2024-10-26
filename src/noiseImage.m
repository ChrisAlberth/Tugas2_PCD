function result = noiseImage(image, noise_type)
    if strcmp(noise_type, 'Salt & Pepper')
        result = imnoise(image, 'salt & pepper', 0.2);
        figure, imshow(result);
    elseif strcmp(noise_type, 'Gaussian')
        result = imnoise(image, 'gaussian', 0, 0.01);
    end
end