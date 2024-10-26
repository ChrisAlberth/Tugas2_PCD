function result = motionBlurImage(image, length, tetha, noise_mean, noise_var)
    PSF = fspecial('motion', length, tetha);
    result = imfilter(image, PSF, 'conv', 'circular');

    if nargin > 3
        result = imnoise(result, 'gaussian', noise_mean, noise_var);
    end
end