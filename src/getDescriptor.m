function descriptors = getDescriptor(contours, fftSize)
    descriptors = zeros(length(contours), fftSize);
    % for each letter
    for i = 1 : length(contours)
        char = contours{i};
        r = [];
        Ri = {};
        R = [];
        % for each contour
        for j = 1 : length(char)
            temp = char{j};
            % find complex sequence
            for k = 1 : size(temp, 1)
                r = [r; temp(k, 1) + 1i * temp(k, 2)];
            end
            % for each contour store fft without dc
            Ri{end + 1} = abs(fft(r));
            Ri{end}(1) = [];
        end
        % interpolate
        % if more than 1 contours, interpolate percent of whole size
        if length(Ri) == 1
            R = Ri{1};
            R = double(interp1(1:size(R), R, 1:fftSize, 'spline'));
        elseif length(Ri) == 2
            temp = Ri{1};
            size1 = floor(0.7 * fftSize);
            temp = double(interp1(1:size(temp), temp, 1:size1, 'spline'));
            R = [R temp];
            temp = Ri{2};
            size2 = fftSize - size1;
            temp = double(interp1(1:size(temp), temp, 1:size2, 'spline'));
            R = [R temp];
        else
            temp = Ri{1};
            size1 = floor(0.5 * fftSize);
            temp = double(interp1(1:size(temp), temp, 1:size1, 'spline'));
            R = [R temp];
            temp = Ri{2};
            size2 = floor(0.25 * fftSize);
            temp = double(interp1(1:size(temp), temp, 1:size2, 'spline'));
            R = [R temp];
            temp = Ri{3};
            size3 = fftSize - size1 - size2;
            temp = double(interp1(1:size(temp), temp, 1:size3, 'spline'));
            R = [R temp];
        end

        descriptors(i, :) = R;
    end
end