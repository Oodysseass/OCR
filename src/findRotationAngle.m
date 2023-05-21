function angle = findRotationAngle(x)
    % preprocess image
    blurred = imgaussfilt(x, 5);

    % % fft
    % logarithmic scale for better results
    X = fft2(blurred);
    shifted = fftshift(X);
    ampl = abs(shifted);
    ampl = log(1 + ampl);

    % % find maximum frequency
    % exclude DC and close frequencies
    [h, w, ~] = size(ampl);
    radius = min(h, w) / 10;
    [X, Y] = meshgrid(1 : w, 1 : h);
    mask = ((X - w / 2) .^ 2 + (Y - h / 2) .^ 2) <= radius ^ 2;
    ampl(mask) = 0;

    % find next max
    [~, max_ind] = max(ampl(:));
    [row, col] = ind2sub(size(ampl), max_ind);
 
    % % find rotation
    % angle of line connecting maximum frequency and center
    center = floor(size(ampl) / 2) + 1;
    dx = col - center(2);
    dy = row - center(1);
    slope = dx / dy;
    angle = atan(slope);

    % convert to deg
    angle = rad2deg(angle);

    % % angles to be tested
    angles = floor(angle - 4) : 0.1 : floor(angle + 4);
    best = -inf;

    for i = 1 : length(angles)
        % reverse rotation
        tryx = rotateImage(x, -angles(i));

        % project
        proj = sum(tryx, 2);
        score = sum(abs(diff(proj)));

        if score > best
            angle = angles(i);
            best = score;
        end
    end

end