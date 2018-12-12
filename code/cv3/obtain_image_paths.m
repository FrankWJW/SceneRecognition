%get image path
function [train_paths, test_paths, train_labels, test_labels] = ... 
    obtain_image_paths(data_path, categories, num_train_per_cat)

num_categories = length(categories); %number of scene categories.

%This paths for each training and test image. By default it will have 1500
%entries (15 categories * 100 training and test examples each)
train_paths = cell(num_categories * num_train_per_cat, 1);
test_paths  = cell(2985, 1);

%The name of the category for each training and test image. With the
%default setup, these arrays will actually be the same, but they are built
%independently for clarity and ease of modification.
train_labels = cell(num_categories * num_train_per_cat, 1);
test_labels  = cell(2985, 1);

for i=1:num_categories
   images = dir( fullfile(data_path, 'train', categories{i}, '*.jpg'));
   for j=1:num_train_per_cat
       train_paths{(i-1)*num_train_per_cat + j} = fullfile(data_path, 'train', categories{i}, images(j).name);
       train_labels{(i-1)*num_train_per_cat + j} = categories{i};
   end
   
   
%    images = dir( fullfile(data_path, 'test', categories{i}, '*.jpg'));
%    for j=1:num_train_per_cat
%        test_paths{(i-1)*num_train_per_cat + j} = fullfile(data_path, 'test', categories{i}, images(j).name);
%        test_labels{(i-1)*num_train_per_cat + j} = categories{i};
%    end

end
images = dir( fullfile(data_path,'test_unlabelled','*.jpg'));
for i=1:2985
    test_paths{i} = fullfile(data_path, 'test_unlabelled', images(i).name);
end