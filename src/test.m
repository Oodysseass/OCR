function prediction = test(mdl1, mdl2, mdl3, contours, descriptors, text)

    prediction = char(zeros(1, length(contours)));
    len = min(length(contours), length(text));
    for i = 1 : len
        if length(contours{i}) == 1
            pred = predict(mdl1, descriptors(i, :));    
        elseif length(contours{i}) == 2
            pred = predict(mdl2, descriptors(i, :));
        else
            pred = predict(mdl3, descriptors(i, :));
        end
        prediction(i) = pred;
    end
end
