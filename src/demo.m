close all
% clc


% % get contours of training image v3
img = imread('../media/text1_v3.png');
whiteLines = uint8(255) * ones(size(img, 1), 50, 3, 'uint8');
img = [whiteLines, img, whiteLines];
whiteLines = uint8(255) * ones(50, size(img, 2), 3, 'uint8');
img = [whiteLines; img; whiteLines];
[contours1, ~] = imageLetters(img);

% % get labels
fid = fopen('../media/text1_v3.txt');
txt = textscan(fid, '%s');
text1 = '';
for i = 1 : length(txt{1})
    text1 = [text1 txt{1}{i}];
end

% % remove all punctuation
for i = length(contours1) : -1 : 1
    if isstrprop(text1(i), 'punct')
        text1(i) = '';
        contours1(i) = [];
    end
end

% % get descriptors of boundaries
featureSize = 100;
descriptors1 = getDescriptor(contours1, featureSize);

% % make train and test set
% random rearrangement
load indexes.mat idx
% n = numel(text1);
% idx = randperm(n);
text = text1(idx);
contours = contours1(idx);
descriptors = descriptors1(idx, :);
num = length(text);

% seperate train and test
trainDescriptors = descriptors(1:floor(0.7 * num), :);
trainContours = contours(1:floor(0.7 * num));
trainText = text(1:floor(0.7 * num));
testDescriptors = descriptors(floor(0.7 * num) + 1:end, :);
testContours = contours(floor(0.7 * num) + 1:end);
testText = text(floor(0.7 * num) + 1:end);

% % train
[mdl1, mdl2, mdl3] = train(trainContours, ...
                                            trainDescriptors, trainText);

% % test on other 30%
pred1 = test(mdl1, mdl2, mdl3, testContours, testDescriptors, testText);

% % get contours of test image
img = imread('../media/text2_rot.png');
contoursTest = imageLetters(img);

% % get labels
fid = fopen('../media/text2.txt');
txt = textscan(fid, '%s');
text2 = '';
for i = 1 : length(txt{1})
    text2 = [text2 txt{1}{i}];
end
text2(1) = '';

% remove all punctuation
for i = length(contoursTest) : -1 : 1
    if isstrprop(text2(i), 'punct')
        text2(i) = '';
        contoursTest(i) = [];
    end
end

% % get descriptors of boundaries
descriptors = getDescriptor(contoursTest, featureSize);

% % test
pred2 = test(mdl1, mdl2, mdl3, contoursTest, descriptors, text2);

acc1 = conChart(testText, pred1)
acc2 = conChart(text2, pred2)

lines = readtext(img, mdl1, mdl2, mdl3, featureSize);
fid = fopen("textPred.txt", "w");

for i = 1 : length(lines)
    fprintf(fid, '%s', lines{i});
    fprintf(fid, '%s', newline);
end
