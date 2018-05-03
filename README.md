# comp4320
## Files and folders description
`preprocess.m` - Uses `remove_background.m` and `image_to_vector.m` to preprocess the images in `data/` and generate a matrix of features and exemplars, which are saved as `image_vectors.mat` (see "Notes to implementors", below). Also takes the first 200 rows of `image_vectors.mat`, and saves them as `image_vectors_small.mat`, which is useful for speedy processing while debugging the project.

`preprocess_sift.m` - Extracts SIFT feature descriptors, clusters them using k-means, then creates a histogram of features per image. This is the Visual Bag of Words technique. Creates a matrix X, where each row of X represents an image and each column represents the number of SIFT feature descriptors in that image that fell into thesaves the matrix to `image_vectors_sift.mat` and `image_vectors_sift_small.mat`.  

`remove_background.m` - Calculates the mean value of every pixel across all images, so they can be assumed to be static background and removed when calculating features

`image_to_vector.m` - Uses a Hilbert curve to turn the 2-dimensional image into a 1-dimensional vector

`hilbert.m` - (Third party, see source code for citation.) Generates a Hilbert curve

`data/` - The data source containing images of pedestrians in a mall. See folder for citation.

`third_party/` - Third party tools

## Notes to implementors
This project assumes Matlab with the image toolbox is installed.
