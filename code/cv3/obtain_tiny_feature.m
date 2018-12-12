%tiny images
function imageFeatures = obtain_tiny_feature(image_paths)
% parameters: image_paths is an N x 1 cell array of strings where each string is an
%  image path on the file system.
% output: imageFeatures is an N x d matrix of resized and then vectorized tiny
%  images. E.g. if the images are resized to 16x16, d would equal 256.

% To build a tiny image feature, simply resize the original image to a very
% small square resolution, e.g. 16x16. You can either resize the images to
% square while ignoring their aspect ratio or you can crop the center
% square portion out of each image. Making the tiny images zero mean and
% unit length (normalizing them) will increase performance modestly.


D = 16; %size of square e.g.16X16
N = length(image_paths);
imageFeatures = zeros(N,(D^2));

for i=1:N
    % Create Tiny Image
    % get path
    path = image_paths{i};
    % read image
    img = imread(path);
    % crop it according to shortest dimention/side
    [img_h, img_w] = size(img);
    min_side = min([img_h img_w]);
    % crop it
    crop_rect = [floor((img_w - min_side)/2), floor((img_h - min_side)/2),  min_side, min_side];
    img_cropped = imcrop(img, crop_rect);%imcrop(img,[xmin ymin width height])
    % resize it
    img_resized = imresize(img_cropped, [D D]);
    % convet to 1D array
    % note that reshape() concatenate matrix columns
    % and we want to concatenate matrix rows, that's why
    % img_resized is transposed before reshaped
    img_array = reshape(img_resized',1,[]);
    imageFeatures(i,:) = img_array;
end