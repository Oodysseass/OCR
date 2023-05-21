function lineChars = getChars(x)
    % size of img
    [M, N] = size(x);

    % projection on vertical axis
    lines = sum(x, 2);
    
    % value of rows when there are no letters
    gapValue = max(lines);
    
    % cell array with cropped every text line
    textLines = {};
    i = 1;
    while i < M
        % start of text line
        if lines(i) ~= gapValue
            % make way for new text line
            textLines{end + 1} = [];
            
            % add white border before text line
            textLines{end} = [ones(3, N)];

            % take whole text line
            while lines(i) ~= gapValue && i < M
                textLines{end} = [textLines{end}; x(i, :)];
                i = i + 1;
            end
            % add white border after text line
            textLines{end} = [textLines{end}; ones(3, N)];
            continue
        end
        i = i + 1;
    end


    % each cell is a cell array with all the chars of a line
    lineChars = cell(1, length(textLines));

    % find letters of each textLine
    for i = 1 : length(textLines)
        line = textLines{i};

        % projection on horizontal axis
        letters = sum(line, 1);

        % value of column when there is no letter
        gapValue = max(letters);

        j = 1;
        chars = {};
        while j < N
            % start of letter
            if letters(j) ~= gapValue

                % make way for new letter
                chars{end + 1} = [];
                
                % add white border before letter
                chars{end} = [ones(size(line, 1), 3)];
    
                % take whole text line
                while letters(j) ~= gapValue && j < N
                    chars{end} = [chars{end} line(:, j)];
                    j = j + 1;
                end
                % add white border after letter
                chars{end} = [chars{end} ones(size(line, 1), 3)];
                continue
            end
            j = j + 1;
        end
        % save line of words
        lineChars{i} = chars;
    end

end