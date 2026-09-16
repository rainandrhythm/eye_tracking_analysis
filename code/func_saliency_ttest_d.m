function [h, p, cohens_d, fix_vals_all, rand_vals_all] = func_saliency_ttest_d(saliency_maps, fix, imgs)

fix_vals_all = [];
rand_vals_all = [];

for j = 1:length(imgs)

    i = imgs(j);
    sal_map = saliency_maps{j};

    % Fixation coordinates
    x = round(fix{i}.x);
    y = round(fix{i}.y);

    % Clamp to image bounds
    x = min(max(x,1), size(sal_map,2));
    y = min(max(y,1), size(sal_map,1));

    if isempty(x)
        continue;
    end

    % Saliency at fixation points
    idx_fix = sub2ind(size(sal_map), y, x);
    fix_vals = sal_map(idx_fix);

    % Saliency at random points
    n = length(fix_vals);
    xr = randi(size(sal_map,2), n, 1);
    yr = randi(size(sal_map,1), n, 1);
    idx_rand = sub2ind(size(sal_map), yr, xr);
    rand_vals = sal_map(idx_rand);

    % Concatenate (force columns)
    fix_vals_all = [fix_vals_all; fix_vals(:)];
    rand_vals_all = [rand_vals_all; rand_vals(:)];
end

% Paired t-test
[h, p] = ttest(fix_vals_all, rand_vals_all);

% Cohen's d
mean_fix  = mean(fix_vals_all);
mean_rand = mean(rand_vals_all);
pooled_std = sqrt((var(fix_vals_all) + var(rand_vals_all)) / 2);
cohens_d = (mean_fix - mean_rand) / pooled_std;

end
