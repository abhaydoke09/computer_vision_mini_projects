function [inliers, transf] = ransac(matches, c1, c2, method)
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Mini project 3

[I] = find(matches>0);
matches_new = matches(I);
c1_new = c1(I,:);
c2_new = c2(matches_new,:);

max_inliers_count = 0;
best_transformation = zeros(2,3);
for iterations = 1:1000
    n = 3;
    msize = numel(matches_new);
    random_indices = randperm(msize, n);
    
% ********************************************************* %
    X = ones(3,n);
    col_counter = 1;
    for i = 1:n
        X(1,col_counter) = c2(matches_new(random_indices(col_counter)),1);
        X(2,col_counter) = c2(matches_new(random_indices(col_counter)),2);
        col_counter = col_counter + 1;
    end

    
    x_prime = zeros(2,n);
    col_counter = 1;
    for i = 1:n
        x_prime(1,col_counter) = c1_new(random_indices(col_counter),1);
        x_prime(2,col_counter) = c1_new(random_indices(col_counter),2);
        col_counter = col_counter + 1;
    end

    
    affine_transformation = x_prime / X;
    
    affine_transformation = affine_transformation;
    
    m = affine_transformation(1:2,1:2);
    t = affine_transformation(1:2,3);
    


    transformed_c2 = (m*c2(matches_new,1:2)'+t)';
    original_c2 = c1_new(:,1:2);

    points_count = size(original_c2,1);
    inliers_count = 0;
    for i = 1:points_count
        distance = sqrt((transformed_c2(i,:) - original_c2(i,:)).^2);
        if distance < 2
            inliers_count = inliers_count+1;
        end
    end
    if inliers_count > max_inliers_count
        max_inliers_count = inliers_count;
        best_transformation = affine_transformation;
    end
end

disp(max_inliers_count);
disp(best_transformation);
transf = best_transformation;
n = size(matches,1);
inliers = zeros(max_inliers_count,1);
inlier_count = 1;


m = best_transformation(1:2,1:2);
t = best_transformation(1:2,3);
for i = 1:n
    if matches(i)>0
        %transformed_c2 = (m * c1(i,1:2)' + t)';
        transformed_c2 = (m * c2(matches(i),1:2)' + t)';
        original_c2 = c1(i,1:2);
        distance = sqrt((transformed_c2 - original_c2).^2);
        if distance < 2
            inliers(inlier_count,1) = matches(i);
            inlier_count = inlier_count + 1;
        end
    end
    
end

transf = best_transformation;



