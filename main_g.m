%% Mini Project
close all 
clear

% load data 
load mp2_images.mat
load mp2_fix.mat 
rng(0);

% for loop with all images  
imgs = [4 6 10];
figure;
for a = 1:length(imgs)
    
    i = imgs(a);
    subplot(2,2,a);
    imagesc(im{i});
    colormap gray;
    hold on;
    plot(fix{i}.x, fix{i}.y, 'r.', 'MarkerSize', 8);
    title(['Fixations Over Im ' num2str(i)]);

end
sgtitle('Fixations Over Images')

%% feature 1: contrast 

% normalized contrast maps- visualizing 

contrast_norm = cell(size(im));
figure;
window = true(7);
for c = 1:length(imgs)

    i = imgs(c);
    contrast_map = stdfilt(im{i}, window);
    contrast_norm{c} = (contrast_map - mean(contrast_map(:))) / std(contrast_map(:));

    subplot(2,2,c);
    imagesc(contrast_norm{c});
    hold on 
    plot(fix{i}.x, fix{i}.y, 'r.', 'MarkerSize', 8);
    colormap gray;
    title(['Normalized Contrast Map: Im ' num2str(i)]);
  
end
sgtitle('Contrast Saliency Maps')

%% Feature 2: Edges 

% generating edge saliency maps

edge_norm = cell(size(im));

figure;
for d = 1:length(imgs)

    i = imgs(d);
    edge_map = edge(im{i}, 'sobel');
    edge_norm{d} = (edge_map - mean(edge_map(:))) / std(edge_map(:)); 

    subplot(2,2,d)
    imagesc(edge_norm{d});
    hold on
    plot(fix{i}.x, fix{i}.y, 'r.', 'MarkerSize', 8);
    colormap gray;
    title(['Edge Saliency: Im ' num2str(i)]);

end
sgtitle('Edge Saliency Maps')

%% Feature 3: Brightness 

bright_norm = cell(size(im));

figure;
for e = 1:length(imgs)

    i = imgs(e);

    % Brightness saliency map (raw image)
    bright_map = im{i};

    % Normalize
    bright_norm{e} = (bright_map - mean(bright_map(:))) / std(bright_map(:));

    % Visualize
    subplot(2,2,e)
    imagesc(bright_norm{e});
    hold on
    plot(fix{i}.x, fix{i}.y, 'r.', 'MarkerSize', 8);
    colormap gray;
    title(['Brightness Saliency: Im ' num2str(i)])

end
sgtitle('Brightness Saliency Maps')

%% Feature 4: Center Bias

center_norm = cell(size(im));

figure;
for g = 1:length(imgs)

    i = imgs(g);

    % Image size (arrays are indexed in reverse)
    [height, width] = size(im{i});

    % Coordinate grid
    [X, Y] = meshgrid(1:width, 1:height);

    % Center of image
    center_x = width / 2;
    center_y = height / 2;

    % Standard deviation (controls spread)
    sigma = 0.25 * min(height, width);

    % Center bias map (2D Gaussian)
    center_map = exp(-((X - center_x).^2 + (Y - center_y).^2) / (2 * sigma^2));

    % Normalize
    center_norm{g} = (center_map - mean(center_map(:))) / std(center_map(:));

    % Visualize
    subplot(2,2,g)
    imagesc(center_norm{g});
    hold on
    plot(fix{i}.x, fix{i}.y, 'r.', 'MarkerSize', 8);
    colormap gray;
    title(['Center Bias Saliency: Im ' num2str(i)])

end
sgtitle('Center Bias Saliency Maps')

%% quantitative analyses 

[h_con, p_con, cohens_d_con] = func_saliency_ttest_d(contrast_norm, fix, imgs); 
disp(['Contrast saliency p-value: ' num2str(p_con)])
disp(['Contrast- Cohen''s d: ' num2str(cohens_d_con)])

[h_edge, p_edge, cohens_d_edge] = func_saliency_ttest_d(edge_norm, fix, imgs); 
disp(['Edge Strength saliency p-value: ' num2str(p_edge)])
disp(['Edge Strength- Cohen''s d: ' num2str(cohens_d_edge)])

[h_bright, p_bright, cohens_d_bright] = func_saliency_ttest_d(bright_norm, fix, imgs); 
disp(['Brightness saliency p-value: ' num2str(p_bright)])
disp(['Brightness- Cohen''s d: ' num2str(cohens_d_bright)])

[h_cen, p_cen, cohens_d_cen] = func_saliency_ttest_d(center_norm, fix, imgs); 
disp(['Center Bias saliency p-value: ' num2str(p_cen)])
disp(['Center Bias- Cohen''s d: ' num2str(cohens_d_cen)])

%% Supplementary Figure: raw contrast maps

% raw contrast maps
figure;
for b = 1:length(imgs)

    i = imgs(b);
    contrast_map = stdfilt(im{i}, window);
    
    subplot(2,2,b);
    imagesc(contrast_map)
    hold on 
    plot(fix{i}.x, fix{i}.y, 'r.', 'MarkerSize', 8);
    colormap gray;
    title(['Raw Contrast Map: Im ' num2str(i)])

end
sgtitle('Raw Contrast Maps')
% 
%% choosing optimal images  

imgs_full = 1:11;

% List of features and corresponding saliency maps
features = {'Contrast','Edge','Brightness','Center Bias'};
sal_maps = {contrast_norm, edge_norm, bright_norm, center_norm};

% Initialize matrices
p_matrix = nan(length(imgs_full), length(features));
d_matrix = nan(length(imgs_full), length(features));

% Fill matrices
for f = 1:length(features)
    for j = 1:length(imgs_full)
        i = imgs_full(j);

        % Call function for ONE image
        [h, p_val, d_val, ~, ~] = func_saliency_ttest_d(sal_maps{f}, fix, i);

        % Fill matrices
        p_matrix(j,f) = p_val;
        d_matrix(j,f) = d_val;
    end
end

% Convert matrices to table for display
p_table = array2table(p_matrix, 'VariableNames', features, 'RowNames', cellstr(num2str(imgs_full')));
d_table = array2table(d_matrix, 'VariableNames', features, 'RowNames', cellstr(num2str(imgs_full')));

disp('P-values table:')
disp(p_table)
disp('Cohens d table:')
disp(d_table)

% Features in order
features = {'Contrast','Edge','Brightness','Center Bias'};

% Extract p-values and Cohen's d for the subset
p_subset = p_matrix(imgs, :);
d_subset = d_matrix(imgs, :);

% Convert to tables for nicer display
p_table_subset = array2table(p_subset, 'VariableNames', features, 'RowNames', cellstr(num2str(imgs')));
d_table_subset = array2table(d_subset, 'VariableNames', features, 'RowNames', cellstr(num2str(imgs')));

% Display
disp('P-values for images 4, 6, 10:')
disp(p_table_subset)

disp('Cohen''s d for images 4, 6, 10:')
disp(d_table_subset)

