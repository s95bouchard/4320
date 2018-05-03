function [output_vector] = image_to_vector(input_image)
% Generate a Hilbert curve
% Each row of [x y] is a pixel coordinate into the image
[x,y]=hilbert(10);

% Scale to our image size. Needs to be square, but can be larger than the
% image.
x=round(x.*700+350)';
y=round(y.*700+350)';

% Test: Visualize the Hilbert curve
% line(x,y); holdon;

% Remove duplicate rows, but keep the rows in order
coords = [x y];
coords = unique(coords, 'rows', 'stable')';

output_vector = zeros([1 640*480]);
image_vector_idx = 1;

% For each point r in the Hilbert curve, find the corresponding pixel value
% in our image, and store it in our image_vector vector at element r.
for r = 1:size(coords,2)
    % Get the (x,y) coordinates that the Hilbert curve generated for point
    % r
    y_coord = coords(1,r);
    x_coord = coords(2,r);
    % Make sure the (x,y) coordinates are within our image. The Hilbert
    % curve had to be square, so we made it larger than our image. Thus,
    % some points on the Hilbert curve will fall outside our image. We'll
    % just exclude those points.
    % We also have to exclude points < 0, because Matlab matrices are
    % indexed at 1.
    if (y_coord > 0 && y_coord<=480) && (x_coord > 0 && x_coord<=640)
        pixel_value = input_image(y_coord, x_coord);
        output_vector(1, image_vector_idx) = pixel_value;
        % Since some of the points in the Hilbert curve were excluded, and
        % we don't want a lot of empty elements in our image_vector, we
        % have a separate index, image_vector_idx, for mapping r to an
        % index in our image_vector.
        image_vector_idx=image_vector_idx + 1;
    end
end

% Test: The sum of pixel values in our input_image should match the sum of
% pixel values in our output_vector. Due to imprecise floating point
% arithmetic, we verify that the sum is less than some small margin of
% error, rather than == 0.
% assert(sum(output_vector) - sum(sum(input_image)) < 0.001);



