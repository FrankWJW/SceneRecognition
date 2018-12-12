clc;clear;
%% Step 1 : Bag of visual words feature based on fixed size densely-sampled pixel patches
run('vlfeat/toolbox/vl_setup')
data_path = '../data/';%get image file path

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

if ~exist('patch_vocab.mat', 'file')
    fprintf('No existing visual word vocabulary found. Computing one from training images\n');
    %Larger values will work better (to a point) but be slower to compute
    vocabulary_size = 300;
    patch_size = 8;
    patch_shift = 25;
    %patch_shift should larger or equal than patch_size
    
    patch_vocab = patch_vocabulary(train_image_paths, vocabulary_size, patch_size, patch_shift);
    save('patch_vocab.mat', 'patch_vocab');
else
    load('patch_vocab.mat', 'patch_vocab');
end
    patch_size = 8;
    patch_shift = 16;
if ~exist('image_patch_feats.mat', 'file')
    fprintf('Bag of patches does not exist for train/test data, Computing one from training/test images\n');
    train_image_feats = obtain_bags_of_patch(train_image_paths, patch_vocab, patch_size, patch_shift);
    test_image_feats = obtain_bags_of_patch(test_image_paths, patch_vocab, patch_size, patch_shift);
    save('image_patch_feats.mat', 'train_image_feats', 'test_image_feats');
else
    load('image_patch_feats.mat', 'train_image_feats', 'test_image_feats');
end
%% Step 2: SVM classifier
% best parameter values for svm classifier
% to classify bag-of-patch
svm_iterations = 100 * 1000;
svm_lambda = 0.00001;

fprintf('Using SVM classifier to predict test set categories');
predicted_categories = SVM_classifier(train_image_feats, ...
            train_labels, test_image_feats, categories, ...
            svm_lambda, svm_iterations);
%% output predicted_labels into a .txt file
writeTxt = fopen('run2.txt','wt');
for i=1:2985
    fprintf(writeTxt,'%s %s\n',strcat(num2str(i),'.jpg'),char(predicted_labels(i)));
end
fclose(writeTxt);