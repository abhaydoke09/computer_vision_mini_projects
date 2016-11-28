% Entry code for mini-project 5

% There are three versions of MNIST dataset
dataTypes = {'digits-normal.mat', 'digits-scaled.mat', 'digits-jitter.mat'};

% You have to implement three types of features
featureTypes = {'pixel', 'hog', 'lbp'};
%featureTypes = {'lbp'};

% Accuracy placeholder
accuracy = zeros(length(dataTypes), length(featureTypes));
trainSet = 1;
testSet = 2; % 2 = validation, 3 = test

for i = 1:length(dataTypes), 
    dataType = dataTypes{i};
    % load data
    load(fullfile('..', 'data', dataType));
    fprintf('+++ Loading digits of dataType: %s\n', dataType);
    
    % Optionally montage the digits in the val set
    % montageDigts(data.x(:,:,:,data.set==2));
    
    for j = 1:length(featureTypes),
        featureType = featureTypes{j};

        % Extract features
        tic;
        features = extractDigitFeatures(data.x, featureType);
        fprintf(' %.2fs to extract %s features for %i images\n', toc, featureType, size(features,2)); 

        % Train model
        tic;
        model = trainModel(features(:, data.set==trainSet), data.y(data.set==trainSet));
        fprintf(' %.2fs to train model\n', toc);

        % Test the model
        ypred = evaluateModel(model, features(:, data.set==testSet));
        y = data.y(data.set==testSet);

        % Measure accuracy
        [acc, conf] = evaluateLabels(y, ypred, false);
        fprintf(' Accuracy [testSet=%i] %.2f%%\n\n', testSet, acc*100);
        accuracy(i,j) = acc;
    end
end

% Print the results in a table
fprintf('+++ Accuracy Table [trainSet=%i, testSet=%i]\n', trainSet, testSet);
fprintf('---------------------------------------------------\n');
fprintf('dataset\t\t\t');
for j = 1:length(featureTypes),
    fprintf('%s\t',featureTypes{j});
end
fprintf('\n');
fprintf('---------------------------------------------------\n');
for i = 1:length(dataTypes),
    fprintf('%s\t', dataTypes{i});
    for j = 1:length(featureTypes),
        fprintf('%.2f\t', accuracy(i,j)*100);
    end
    fprintf('\n');
end

% Once you have optimized the hyperparameters, you can report test accuracy
% by setting testSet=3. You should not optimize your hyperparameters on the
% test set. That would be cheating.