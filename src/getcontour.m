function c = getcontour(x)
    % add some white border just for safety
    x = [ones(size(x, 1), 10) x ones(size(x, 1), 10)];
    x = [ones(10, size(x, 2)); x; ones(10, size(x, 2))];

    % fix letter image
    sel = strel('disk', 2);
    x = imopen(x, sel);

    sel = strel('disk', 1);
    xdil = imdilate(x, sel);

    xborder = xdil - x;
    xthin = bwmorph(xborder, 'thin', Inf);

    [M, N] = size(xthin);
    c = {};
    i = 1;
    while i < M
        if all(xthin(i, :) == 0)
            i = i + 1;
            continue
        end
        % threshold for randomly left pixels
        if nnz(xthin) < 10
            break;
        end
        % start from top left pixel of contour
        row = i;
        col = find(xthin(i, :), 1, 'first');
        [xthin, c{end + 1}] = contour(xthin, row, col);
        i = 1;
    end
    
    % for j = 1 : length(c)
    %     img = zeros(M, N);
    %     arr = c{j};
    %     for i = 1 : size(arr, 1)
    %         img(arr(i, 1), arr(i, 2)) = 1;
    %     end
    %     figure, imshow(img)
    % end
end

% actual get contour algorithm
function [x, arr] = contour(x, row, col)
    % starting points
    i = row;
    j = col;
    stepN = 1;
    previousPoint = [row col];

    arr = [];
    while 1
        if x(i, j) == 1
            % remove point from image
            x(i, j) = 0;

            % add point to contour
            arr = [arr; i j];
            previousPoint = [i j];
            j = j + stepN;
            continue
        else
            % go to previously added point to check neighbors
            i = previousPoint(1);
            j = previousPoint(2);
        end

        % check NE
        if x(i - 1, j + 1) == 1
            i = i - 1;
            j = j + 1;
            stepN = 1;

        % check SE
        elseif x(i + 1, j + 1) == 1
            i = i + 1;
            j = j + 1;
            stepN = 1;

        % check S
        elseif x(i + 1, j) == 1
            i = i + 1;
            j = j;
            stepN = 1;

        % check SW
        elseif x(i + 1, j - 1) == 1
            i = i + 1;
            j = j - 1;
            stepN = -1;

        % check NW
        elseif x(i - 1, j - 1) == 1
            i = i - 1;
            j = j - 1;
            stepN = -1;

        % check N
        elseif x(i - 1, j) == 1
            i = i - 1;
            j = j;
            stepN = 1;
        
        % if there are no neighboring points we are done
        else
            break
        end
    end
end