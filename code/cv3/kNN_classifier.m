%kNN classifier
function predicted_labels = kNN_classifier(train_image_feats, train_labels, test_image_feats, categories, neighbors)
% inputs:
% train_image_feats: N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels: an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats: an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% categories: total 15 categories here
% neighbors: k value
% output:
% predicted_labels : an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

% loop on all the test features
% and for each one of them calculate the list of
% distances between it and the train features
% then sort all these distances ascendingly (shortest distance first)
% then according to how many k you have
% predict the label of this feature
% finally, return this list of predicted labels

train_kNN = size(train_image_feats, 1);
test_kNN = size(test_image_feats, 1);

predicted_labels = cell(test_kNN, 1);
predicted_categories_nums = zeros(test_kNN, 1);
K = neighbors;

for i=1:test_kNN
    
    distances = zeros(train_kNN,1);
    for j=1:train_kNN
        distances(j) = vl_alldist2(test_image_feats(i,:)', train_image_feats(j,:)', 'l2');%calculating the L2 norm
    end    
    
    % note that idx is the list of indeces
    % ironically, I only need the indeces of the sorted distances
    % for example: distances(idx(i)) = sorted_distances(i);
    [~, idx] = sort(distances);
    
    % now for the first k elements, get what are their labels
    % and see which is the most mentioned label in these k-elements
    k_labels = cell(K, 1);
    for j=1:K
        k_labels(j) = train_labels(idx(j));
    end
    k_labels_numbers = labels_numbers(k_labels, categories);
    
    % see which label was the most mentioned
    occurances = zeros(K, 1);
    for j = 1:K
        occurances(j) = sum(k_labels_numbers == k_labels_numbers(j));
    end
    [~, index] = ismember(max(occurances), occurances);
    predicted_labels{i} = k_labels{index};
    predicted_categories_nums(i) = k_labels_numbers(index);
end

end