function [mdl1, mdl2, mdl3] = train(contours, descriptors, text)
    % % separate classes
    class1 = [];
    class2 = [];
    class3 = [];
    labels1 = [];
    labels2 = [];
    labels3 = [];
    
    for i = 1 : length(descriptors)
        if length(contours{i}) == 1
            class1 = [class1; descriptors(i, :)];
            labels1 =  [labels1; text(i)];
        elseif length(contours{i}) == 2
            class2 = [class2; descriptors(i, :)];
            labels2 =  [labels2; text(i)];
        else
            class3 = [class3; descriptors(i, :)];
            labels3 =  [labels3; text(i)];
        end
    end

    % % train
    mdl1 = fitcknn(class1, labels1);
    mdl2 = fitcknn(class2, labels2);
    mdl3 = fitcknn(class3, labels3);
end
