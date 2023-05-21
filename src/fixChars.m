function lineChars = fixChars(lineChars)
    for i = 1 : length(lineChars)
        chars = lineChars{i};
        for j = 1 : length(chars)
            scale = 250 / max(size(chars{j}));
            chars{j} = imbinarize(imresize(chars{j}, scale));
        end

        j = 1;
        n = length(chars);
        while j < n
            % close operation so that they unified are separated
            sel = strel('disk', 4);
            temp = imclose(chars{j}, sel);
            tempLines = getChars(temp);

            l1 = length(getChars(chars{j}));
            l2 = length(tempLines);
            % underlines were deleted from closing
            if l1 > l2
                % chars{j} was just an underline, remove it
                if l2 == 0
                    chars = {chars{1:j - 1}, chars{j + 1:end}};
                    j = j - 1;
                % underline was removed from closing
                elseif l2 == 1
                    tempChars = tempLines{1};
                    chars = {chars{1:j - 1}, tempChars{1:end}, ...
                        chars{j + 1:end}};
                    j = j - 1;
                % it was i or j with underline, keep only the letter
                elseif l2 == 2
                    % we understand which one is the letter
                    % from the number of black pixels
                    tempChars1 = tempLines{1};
                    tempChars2 = tempLines{2};
                    black1 = sum(tempChars1{1}(:) == 0);
                    black2 = sum(tempChars2{1}(:) == 0);
                    if black1 > black2
                        chars = {chars{1:j - 1}, tempChars1{1}, ...
                            chars{j + 1:end}};
                    else
                        chars = {chars{1:j - 1}, tempChars2{1}, ...
                            chars{j + 1:end}};
                    end
                    j = j - 1;
                end
            % one line = not underlined
            % or not i or j
            elseif length(tempLines) == 1
                tempChars = tempLines{1};
                % more than 1 letter
                if length(tempChars) > 1
                    chars = {chars{1:j - 1}, tempChars{1:end}, ...
                        chars{j + 1:end}};
                    j = j - 1;
                end
            % two lines either i, j or underlined
            elseif length(tempLines) == 2
                tempChars1 = tempLines{1};
                tempChars2 = tempLines{2};
                % it's a letter and a dot, keep only the letter
                if length(tempChars1) == 1 && length(tempChars2) == 1
                    black1 = sum(tempChars1{1}(:) == 0);
                    black2 = sum(tempChars2{1}(:) == 0);
                    if black1 > black2
                        chars = {chars{1:j - 1}, tempChars1{1}, ...
                            chars{j + 1:end}};
                    else
                        chars = {chars{1:j - 1}, tempChars2{1}, ...
                            chars{j + 1:end}};
                    end
                    j = j - 1;
                % else it's underlined letters
                % throw underline to garbage
                % (or this so really very much good algorithm)
                else
                    chars = {chars{1:j - 1}, tempChars1{1:end}, ...
                        chars{j + 1:end}};
                    j = j - 1;
                end
            % underlined i or j
            % maybe unified with other letters
            elseif length(tempLines) == 3
                % keep letters
                tempChars = tempLines{2};
                chars = {chars{1:j - 1}, tempChars{1:end}, ...
                    chars{j + 1:end}};
                j = j - 1;
            end

            n = length(chars);
            j = j + 1;
        end

        lineChars{i} = chars;
    end
end
