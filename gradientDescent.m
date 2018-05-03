function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters, lambda)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by 
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCost) and gradient here.
    %

        
    h = X * theta;
    residual = h - y;
    
    gradient = (alpha/m) * residual' * X;
    
    reg_factor = (1 - (alpha * lambda)/m);
    
    theta = theta * reg_factor;
    
    theta = theta - gradient';

    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCost(X, y, theta, lambda);
    
    % Output progress
    fprintf('%.2d% ',(iter/num_iters)*100)
    fprintf('...\n')

end

plot(1:num_iters, J_history)

end
