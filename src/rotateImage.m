function imgRot = rotateImage(x, angle)
    if ndims(x) == 3
        % starting size
        [M0, N0, ~] = size(x);
    
        % find new size so whole image fits
        M = ceil(abs(M0 * cosd(angle)) + abs(N0 * sind(angle)));
        N = ceil(abs(M0 * sind(angle)) + abs(N0 * cosd(angle)));

    
        % find center
        center = ([M0 N0] + 1) / 2;
        newCenter = ([M N] + 1) / 2;

        % initialize to black background
        imgRot = zeros(M, N, 3, 'uint8');


        % % we work using coordinates, not array indexes
        % calculate new coordinates of each point
        for i = 1 : N
            for j = 1 : M
                % get new coordinates
                % center is substracted because 0, 0 is actually top left
                ii = (i - newCenter(2)) * cosd(angle) - ...
                    (j - newCenter(1)) * sind(angle) + center(2);
                jj = (i - newCenter(2)) * sind(angle) + ...
                    (j - newCenter(1)) * cosd(angle) + center(1);

                if ii >= 1 && ii <= N0 && jj >= 1 && jj <= M0
                    ii = round(ii);
                    jj = round(jj);

                    % reverse because of coordinates
                    imgRot(j, i, :) = x(jj, ii, :);
                end
            end
        end
    else
        [M0, N0] = size(x);
    
        M = ceil(abs(M0 * cosd(angle)) + abs(N0 * sind(angle)));
        N = ceil(abs(M0 * sind(angle)) + abs(N0 * cosd(angle)));
    
        imgRot = zeros(M, N);
    
        center = ([M0 N0] + 1) / 2;
        newCenter = ([M N] + 1) / 2;
        
        for i = 1 : N
            for j = 1 : M
                ii = (i - newCenter(2)) * cosd(angle) - ...
                    (j - newCenter(1)) * sind(angle) + center(2);
                jj = (i - newCenter(2)) * sind(angle) + ...
                    (j - newCenter(1)) * cosd(angle) + center(1);
                
                if ii >= 1 && ii <= N0 && jj >= 1 && jj <= M0
                    ii = round(ii);
                    jj = round(jj);
                    
                    imgRot(j, i) = x(jj, ii);
                end
            end
        end
    end

    
end
