fprintf('Calculating background mean ...\n')
background = remove_background();

img_name = './data/mall_dataset/frames/seq_%.6d.jpg';

fprintf('Converting images to vectors using Hilbert curve ...\n')

X = zeros(2000, 640*480);

for n = 1:2000
    image_n = imread(sprintf(img_name,n));
    image_n = double(image_n) - background;
    image_n = rgb2gray(image_n);   
    image_vector=image_to_vector(image_n);
    X(n, :) = image_vector;
    % Output progress
    if (mod(n,20)==0)
        fprintf('%.2d% ',(n/2000)*100)
        fprintf('...\n')
    end
end

fprintf('Calculating counts of people in each image ...\n')
load('./data/mall_dataset/mall_gt.mat');
y = zeros(2000, 1);

for n = 1:2000
    % Use size to find the count. Possible improvement: use actual
    % locations of people, instead of just number of people.
    count = size(frame{n}.loc, 1);
    y(n) = count;
    % Output progress
    if (mod(n,20)==0)
        fprintf('%.2d% ',(n/2000)*100)
        fprintf('...\n')
    end
end

fprintf('Saving image_vectors.mat...\n')
save("image_vectors.mat","X","y","-v7.3");

% Create a small feature set for debugging the application
fprintf('Saving image_vectors_small.mat...\n')
X = X(1:200,:);
y = y(1:200);
save("image_vectors_small.mat","X","y","-v7.3");
