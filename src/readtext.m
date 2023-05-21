function lines = readtext(x, mdl1, mdl2, mdl3, featureSize)
    % find contours and chars of each line
    [contours, lineChars] = imageLetters(x);

    % find descriptors of contours
    descriptors = getDescriptor(contours, featureSize);

    % find characters
    text = char(zeros(1, length(contours)));
    for i = 1 : length(contours)
        if length(contours{i}) == 1
            pred = predict(mdl1, descriptors(i, :));
        elseif length(contours{i}) == 2
            pred = predict(mdl2, descriptors(i, :));
        else
            pred = predict(mdl3, descriptors(i, :));
        end
        text(i) = pred;
    end
    
    % separate lines
    lines = cell(1, length(lineChars));
    for i = 1 : length(lines)
        lines{i} = char(zeros(1, length(lineChars{i})));
    end

    k = 1;
    for i = 1 : length(lines)
        for j = 1 : length(lines{i})
            lines{i}(j) = text(k);
            k = k + 1;
        end
    end

end
