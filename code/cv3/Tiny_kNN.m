clc;clear;
%% Step 1: Tiny image features
run('vlfeat/toolbox/vl_setup')
data_path = '../../data/';%get image file path

%set categories we need
categories = {'Kitchen', 'Store', 'Bedroom', 'LivingRoom', 'Office', ...
    'Industrial', 'Suburb', 'InsideCity', 'TallBuilding', 'Street', ...
    'Highway', 'OpenCountry', 'Coast', 'Mountain', 'Forest'};


%number of training examples per category to use. Max is 100.
num_train_per_cat = 100;

%get file path for both training and testing images
fprintf('Getting paths and labels for all train and test data\n')
[train_image_paths, test_image_paths, train_labels, test_labels] = ...
    obtain_image_paths(data_path, categories, num_train_per_cat);
%   train_image_paths  1500x1   cell
%   test_image_paths   2985x1   cell
%   train_labels       1500x1   cell
%   test_labels        2985x1   cell

%calling nature order sort function
[test_image_paths,~] = sort_nat(test_image_paths);

fprintf('Using tiny image representation for images\n');

if ~exist('tiny_images.mat', 'file')
    fprintf('Bag of sifts does not exist for train/test data, Computing one from training/test images\n');
    train_image_feats = obtain_tiny_feature(train_image_paths);
    test_image_feats = obtain_tiny_feature(test_image_paths);
    save('tiny_images.mat', 'train_image_feats', 'test_image_feats');
else
    load('tiny_images.mat', 'train_image_feats', 'test_image_feats');
end

fprintf('Finish calculating tiny image features for training/test data\n');
%% Step 2: K-nearest neighbour classifier

% after many validations, this is the best k value
% for k-NN classifier when tiny-image is used
K = 6;

fprintf('Using kNN classifier to predict test set categories\n');
predicted_labels = kNN_classifier( ...
            train_image_feats, train_labels, test_image_feats, ...
            categories, K);
        
%% output predicted_labels into a .txt file
writeTxt = fopen('run1.txt','wt');
for i=1:2985
    fprintf(writeTxt,'%s %s\n',strcat(num2str(i),'.jpg'),char(predicted_labels(i)));
end
fclose(writeTxt);