function [contoursT, lineChars] = imageLetters(img)
    % % preprocess
    % grayscale
    grayscale = rgb2gray(img);
    % turn to binary
    binary = double(imbinarize(grayscale));
    
    % % reverse rotation
    angle = findRotationAngle(binary);
    if angle ~= 0
        img = rotateImage(img, -angle);
    end
    
    % % fix resolution at 4k
    scale = 4000 / max(size(img));
    binary = imbinarize(rgb2gray(imresize(img, scale)));
    
    % % remove black border
    flag = true;
    while flag
        flag = false;
    
        N = size(binary, 2);
        if sum(binary(1, :)) ~= N
            binary(1, :) = [];
            flag = true;
        end
    
        if sum(binary(end, :)) ~= N
            binary(end, :) = [];
            flag = true;
        end
    
        M = size(binary, 1);
        if sum(binary(:, 1)) ~= M
            binary(:, 1) = [];
            flag = true;
        end
    
        if sum(binary(:, end)) ~= M
            binary(:, end) = [];
            flag = true;
        end
    end
    
    % % find characters
    lineChars = getChars(binary);

    % fix unified characters
    lineChars = fixChars(lineChars);

    % get boundaries
    contoursT = {};
    for i = 1 : length(lineChars)
        chars = lineChars{i};
        for j = 1 : length(chars)
            contoursT{end + 1} = getcontour(chars{j});
        end
    end
end

