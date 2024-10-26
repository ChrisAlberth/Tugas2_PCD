classdef ImageProcessor
    methods
        function result = conv(~, image, mask)
            [sizeMask, ~] = size(mask);
            disp(sizeMask);
            
            offset = floor(sizeMask / 2);
            padded_image = padarray(image, [offset, offset], 'replicate');
            [row, col] = size(padded_image);
            
            imageDouble = im2double(padded_image);
            ImageResult = imageDouble;
            
            for i = 1+offset:(row - offset)
                for j = 1+offset:(col - offset)

                    subset = imageDouble(i - offset:i + offset, j - offset:j + offset);
                    ImageResult(i, j) = dot(subset(:), mask(:));

                end
            end
            original_size_result = ImageResult(offset+1:end-offset, offset+1:end-offset, :);
            result = im2uint8(original_size_result);
        end

        function result = ipf(~, image, d0, highkalow)
            [m, n] = size(image);
            imageDouble = im2double(image);

            p = 2*m;
            q = 2*n;

            padded_image = zeros(p, q);
            padded_image(1:m, 1:n) = imageDouble(1:m, 1:n);

            %fft
            image_fft = fftshift(fft2(padded_image));

            %mask
            u = 0:(p-1);
            v = 0:(q-1);
            
            idx = find(u > p/2);
            u(idx) = u(idx) - p;
            idy = find(v > q/2);
            v(idy) = v(idy) - q;

            [V, U] = meshgrid(v, u);
            d = sqrt(U.^2 + V.^2);
            
            mask = double( d <= d0);

            if highkalow
                mask = 1 - mask;
            end

            mask = fftshift(mask);

            imageResult = mask.*image_fft;
            imageResult = ifft2(ifftshift(imageResult));

            result = im2uint8(imageResult(1:m, 1:n));
        end

        function result = gpf(~, image, d0, highkalow)
            [m, n] = size(image);
            imageDouble = im2double(image);

            p = 2*m;
            q = 2*n;

            padded_image = zeros(p, q);
            padded_image(1:m, 1:n) = imageDouble(1:m, 1:n);

            %fft
            image_fft = fftshift(fft2(padded_image));

            %mask
            u = 0:(p-1);
            v = 0:(q-1);
            
            idx = find(u > p/2);
            u(idx) = u(idx) - p;
            idy = find(v > q/2);
            v(idy) = v(idy) - q;

            [V, U] = meshgrid(v, u);
            d = sqrt(U.^2 + V.^2);
            
            mask = exp(-(d.^2)./(2*(d0^2)));

            if highkalow
                mask = 1 - mask;
            end

            mask = fftshift(mask);

            imageResult = mask.*image_fft;
            imageResult = ifft2(ifftshift(imageResult));

            result = im2uint8(imageResult(1:m, 1:n));
        end

        function result = bpf(~, image, d0, eN, highkalow)
            [m, n] = size(image);
            imageDouble = im2double(image);

            p = 2*m;
            q = 2*n;

            padded_image = zeros(p, q);
            padded_image(1:m, 1:n) = imageDouble(1:m, 1:n);

            %fft
            image_fft = fftshift(fft2(padded_image));

            %mask
            u = 0:(p-1);
            v = 0:(q-1);
            
            idx = find(u > p/2);
            u(idx) = u(idx) - p;
            idy = find(v > q/2);
            v(idy) = v(idy) - q;

            [V, U] = meshgrid(v, u);
            d = sqrt(U.^2 + V.^2);
            
            mask = 1./(1 + (d./d0).^(2*eN));

            if highkalow
                mask = 1 - mask;
            end

            mask = fftshift(mask);

            imageResult = mask.*image_fft;
            imageResult = ifft2(ifftshift(imageResult));

            result = im2uint8(imageResult(1:m, 1:n));
        end

        function result = pikirsendiri(~, image, d0, hg, lg, highkalow)
            [m, n] = size(image);
            imageDouble = double(image);

            p = 2*m;
            q = 2*n;

            padded_image = zeros(p, q);
            temp_img = log(imageDouble(1:m, 1:n) + 1);
            padded_image(1:m, 1:n) = temp_img;

            %fft
            image_fft = fftshift(fft2(padded_image));

            %mask
            u = 0:(p-1);
            v = 0:(q-1);
            
            idx = find(u > p/2);
            u(idx) = u(idx) - p;
            idy = find(v > q/2);
            v(idy) = v(idy) - q;

            [V, U] = meshgrid(v, u);
            d = sqrt(U.^2 + V.^2);
            
            mask = exp(-(d.^2)./(2*(d0^2)));

            if highkalow
                mask = 1 - mask;
            end

            mask = (hg - lg) * mask + lg;

            mask = fftshift(mask);

            imageResult = mask.*image_fft;
            imageResult = ifft2(ifftshift(imageResult));

            result = uint8(exp(imageResult(1:m, 1:n)) - 1);
        end
    end
end