% Amit Peled
% 03/08/2021
% Collagifier

%% Clear previous data, close figures, and clear command window
clear all;
close all;
clc;

%% Plan:
% 1. Import Image Library and Calculate Mean RGB Values
% 2. Import Original Image
% 3. Get RGB Mean Values of 20x20 Pixel Blocks of Original
% 4. Lay image Library in the same size area as the Original
% 5. Match each Average RGB value of the library Image to the nearest RGB value of the Original 20x20 pixel block using Differences
% 6. Patch Corresponding Library Image to correct 20x20 block

%% Step 1: Import Image Library and Calculate Mean RGB Values

% Number of photos in the image library
n = 81;

% Initialize an array to store RGB values of each imported image
rgbSmallImage = zeros(n, 1, 3);

% Import images from the image library and calculate mean RGB values for each image
for i = 1:n
    name = strcat("images/image_library", '/yoda_', num2str(i), '.png');
    imageData = imresize(imread(name), [20, 20]); % Resize the image to 20x20 pixels
    lib{1, i} = imageData; % Store the image data in a cell array
    rSmallImage = cast(imageData(:, :, 1), 'double'); % Red values as double
    gSmallImage = cast(imageData(:, :, 2), 'double'); % Green values as double
    bSmallImage = cast(imageData(:, :, 3), 'double'); % Blue values as double

    % Calculate the average of each color and store them in the RGB matrix as normalized values (division by 255)
    rgbSmallImage(i, :, :) = [mean(rSmallImage, 'all'), mean(gSmallImage, 'all'), mean(bSmallImage, 'all')]/255;
end

%% Step 2: Import Base Image, Calculate Mean RGB Values of 20x20px Blocks, Place Corresponding SmallImage Over Block

% Import the original image to collage over
orig = imread('images/base_images/orig3.jpg');
origw = 5000;
orig = imresize(orig, [origw, origw]); % Resize the Original Image to 5000px x 5000px

% Calculate the number of rows and columns if we split into 20x20px blocks
row = origw / 20;
col = origw / 20;

% Initialize an array to store RGB values of each 20x20 pixel block
rgbOrig = zeros(row, col, 3);

% Create an array of zeros with the same size as the Original Image to patch SmallImages with corresponding blocks
newImage = cast(zeros(size(orig)), 'uint8');

for h = 1:row % 20 pixels on each row
    for w = 1:col % 20 pixels on each column
        redOrig = cast(orig(20*(h-1) + 1 : 20*h, 20*(w-1) + 1 : 20*w, 1), 'double'); % Red values as double
        greenOrig = cast(orig(20*(h-1) + 1 : 20*h, 20*(w-1) + 1 : 20*w, 2), 'double'); % Green values as double
        blueOrig = cast(orig(20*(h-1) + 1 : 20*h, 20*(w-1) + 1 : 20*w, 3), 'double'); % Blue values as double

        % Calculate the average of each color and store them in the RGB matrix as normalized values (division by 255)
        rgbOrig(h, w, :) = [mean(redOrig, 'all'), mean(greenOrig, 'all'), mean(blueOrig, 'all')]/255;

        % Find the index of the library image with the closest RGB values to the current 20x20 pixel block
        [~, idx] = min(sum((rgbOrig(h, w, :) - rgbSmallImage).^2, 3));

        % Use the index of the SmallImage for the selected block and patch it over the block, producing a newImage
        newImage(20*(h-1) + 1 : 20*h, 20*(w-1) + 1 : 20*w, :) = lib{1, idx};
    end
end

% Display the original image
figure(1);
imshow(orig);

% Display the resulting image
figure(2);
imshow(newImage);
