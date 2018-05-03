function [image_mean] = remove_background()
%REMOVE_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here

img_name = './data/mall_dataset/frames/seq_%.6d.jpg';

image_sum = imread(sprintf(img_name,1));
image_sum = double(image_sum);

for n = 2:2000
    image_n = imread(sprintf(img_name,n));
    image_n = (image_n);
    
    image_sum = image_sum + double(image_n);
end

image_mean = image_sum / 2000;

% Test
%img_index = 970;
%image_test = (imread(sprintf(img_name,img_index)));
%image_test_background = double(image_test) - image_mean;
%image_test_background = rgb2gray(image_test_background);
%imshowpair(image_test, image_test_background, 'montage'); hold on;

