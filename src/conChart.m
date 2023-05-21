function acc = conChart(txt, pred)
    true1 = '';
    true2 = '';
    true3 = '';
    pred11 = '';
    pred22 = '';
    pred33 = '';
    
    for i = 1 : length(txt)
        if txt(i) ~= 'a' && txt(i) ~= 'A' && txt(i) ~= 'b' && ...
                txt(i) ~= 'B' && txt(i) ~= 'd' && txt(i) ~= 'D' && ...
                txt(i) ~= 'e' && txt(i) ~= 'g' && txt(i) ~= 'o' && ...
                txt(i) ~= 'O' && txt(i) ~= 'p' && txt(i) ~= 'P' && ...
                txt(i) ~= 'q' && txt(i) ~= 'Q' && txt(i) ~= '4' && ...
                txt(i) ~= '0' && txt(i) ~= '6' && txt(i) ~= '8' && ...
                txt(i) ~= '9'
            true1 = [true1 txt(i)];
            pred11 = [pred11 pred(i)];
        elseif txt(i) == 'a' || txt(i) == 'A' || txt(i) == 'b' || ...
                txt(i) == 'd' || txt(i) == 'D' || ...
                txt(i) == 'e' || txt(i) == 'g' || txt(i) == 'o' || ...
                txt(i) == 'O' || txt(i) == 'p' || txt(i) == 'P' || ...
                txt(i) == 'q' || txt(i) == 'Q' || txt(i) == '4' || ...
                txt(i) == '6' || ...
                txt(i) == '9'
            true2 = [true2 txt(i)];
            pred22 = [pred22 pred(i)];
        else
            true3 = [true3 txt(i)];
            pred33 = [pred33 pred(i)];
        end
    end
    
    figure, confusionchart(cellstr(true1(:)), cellstr(pred11(:)));
    figure, confusionchart(cellstr(true2(:)), cellstr(pred22(:)));
    figure, confusionchart(cellstr(true3(:)), cellstr(pred33(:)));

    labels = unique([txt pred]);
    orders = cellstr(labels(:)).';
    conf = confusionmat(cellstr(txt(:)).', cellstr(pred(:)).', 'Order', orders);
    total = sum(conf(:));
    totalClass = sum(conf, 2);
    classAcc = diag(conf) ./ totalClass;
    valid = ~isnan(classAcc);
    acc = sum(classAcc(valid) .* totalClass(valid)) / total;    
end