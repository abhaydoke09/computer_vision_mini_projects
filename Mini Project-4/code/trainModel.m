function model = trainModel(x, y)
param.lambda = 0.001;  % Regularization term
param.maxiter = 1000; % Number of iterations
param.eta = 0.001;     % Learning rate

model = multiclassLRTrain(x, y, param);