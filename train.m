% Get the expected counts
% See ./data/mall_dataset/demo.m to understand data set

load("image_vectors.mat"); % Use the Hilbert curve with background removed features
%load("image_vectors_sift.mat"); % Use the SIFT Bag of Words features

m = size(X,1);

% Save memory, avoid OOM exception by converting to single
X = single(X);
y = single(y);

X = [ones(m, 1) X]; % Add a column of ones to x

for iter = 1:20
    
    % Split X and y into training and test data
    test_count = 200;
    
    [X_test, sampled_idx] = datasample(X, test_count);
    y_test = y(sampled_idx,:);
    remaining_rows = true(1,m);
    remaining_rows(sampled_idx) = false;
    X_train = X(remaining_rows, :);
    y_train = y(remaining_rows, :);
    
    %clear X; % Save memory by clearing X

    theta = zeros(size(X_train,2),1);

    % run gradient descent
    iterations = 50;
    alpha = 0.000001;
    lambda = 5;

    theta = gradientDescent(X_train, y_train, theta, alpha, iterations, lambda);

    % Calculate effectiveness
    predicted_counts=X_test*theta;
    fprintf("Average count error:")
    count_error=mean(abs(y_test-predicted_counts))
    fprintf("Correct percent:")
    100 - ((count_error / mean(y_test)) * 100)
end