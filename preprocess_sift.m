run('./third_party/vlfeat-0.9.21/toolbox/vl_setup');

img_name = './data/mall_dataset/frames/seq_%.6d.jpg';

fprintf('Calculating SIFT descriptors...\n')

% Contains descriptors for all the images, where each 128-dimension column
% vector is a single descriptor for some image.
%all_descriptors = zeros(128, 1);

for n = 1:2000
    image_n = imread(sprintf(img_name,n));
    image_n = single(rgb2gray(image_n));  
    
    % Calculate the descriptors of the image using SIFT
    [~,descriptors] = vl_sift(image_n);
    
    % Use a cell array, where each cell contains all the descriptors for 
    % that image
    all_descriptors{n} = descriptors;
    
    % Output progress
    if (mod(n,20)==0)
        fprintf('%.2d% ',(n/2000)*100)
        fprintf('...\n')
    end
end

% Explanation of kmeans: https://stackoverflow.com/questions/24645068/k-means-clustering-major-understanding-issue
% Cluster all the descriptors into numClusters clusters.
% Get the centerpoint of each cluster (in 128-dimensional space,
% since descriptors are 128-dimensional).
numClusters = 5;
% Use cell2mat to append all the descriptor columns for every image
% into one big matrix, where each column represents one descriptor from
% some image.
fprintf('Clustering into %.2d% clusters using integer k-means...\n', numClusters)
[centers, ~] = vl_ikmeans(cell2mat(all_descriptors), numClusters); 

centers = single(centers);

fprintf('Creating histograms of how many of many features fall into each cluster for each image...\n')
% Bag of words implementation
% Source: https://stackoverflow.com/questions/23104750/bag-of-words-bow-in-vlfeat
% Retrieved 2018-04-21
% For explanation, see https://ianlondon.github.io/blog/visual-bag-of-words/
X = zeros(2000, numClusters);
for n = 1:2000
    H = zeros(1,numClusters);
    
    descriptors = single(all_descriptors{n});

    for i=1:size(descriptors,2)
        [~, k] = min(vl_alldist(descriptors(:,i), centers)) ;
        H(k) = H(k) + 1;
    end
    
    X(n,:) = H;
    
    % Output progress
    if (mod(n,20)==0)
        fprintf('%.2d% ',(n/2000)*100)
        fprintf('...\n')
    end
end

% TODO: Create a function with this common code, since it's shared by
% preprocess_sift.m and preprocess.m
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

fprintf('Saving image_vectors_sift_5_clusters.mat...\n')
save("image_vectors_sift_5_clusters.mat","X","y","-v7.3");

% Create a small feature set for debugging the application
fprintf('Saving image_vectors_sift_5_clusters_small.mat...\n')
X = X(1:200,:);
y = y(1:200);
save("image_vectors_sift_5_clusters_small.mat","X","y","-v7.3");