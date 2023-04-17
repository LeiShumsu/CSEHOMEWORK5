% Load the dataset and preprocess
load('USPS.mat');
A_mean = mean(A);
A_centered = bsxfun(@minus, A, A_mean);
% Compute SVD and reconstruct images for p_values
[U, S, V] = svd(A_centered, 'econ');
p_values = [10, 50, 100, 200];
errors = zeros(1, length(p_values));
A_reconstructed_list = cell(1, length(p_values));
for i = 1:length(p_values)
    p = p_values(i);
    V_reduced = V(:, 1:p);
    A_reconstructed = A_centered * V_reduced * V_reduced';
    A_reconstructed_list{i} = A_reconstructed;
    errors(i) = sum(sum((A_centered - A_reconstructed).^2));
end
disp(array2table(errors, 'VariableNames', {'p_10', 'p_50', 'p_100', 'p_200'}));
% Visualize reconstructed images
image_indices = [1, 2];
figure;
for i = 1:length(p_values)
    for j = 1:length(image_indices)
        subplot(length(image_indices), length(p_values), (j - 1) * length(p_values) + i);
        img = reshape(A_reconstructed_list{i}(image_indices(j), :) + A_mean, 16, 16);
        imshow(img', []);
        title(['Image ' num2str(image_indices(j)) ' (p = ' num2str(p_values(i)) ')']);
    end
end