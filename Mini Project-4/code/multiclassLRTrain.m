function model = multiclassLRTrain(x, y, param)
% Add a bias term
x = cat(1, x, ones(1, size(x,2)));

classLabels = unique(y);
numClass = length(classLabels);
numFeats = size(x,1);
numData = size(x,2);

trueProb = zeros(numClass, numData);
for c = 1:numClass, 
    isClass = y == classLabels(c);
    trueProb(c, isClass) = 1;
end
assert(all(sum(trueProb,1) == 1));

% Initialize weights randomly
model.w = randn(numClass, numFeats)*0.01;

% verbosity
verboseOutput = false;
for iter = 1:param.maxiter,
    prob = softmax(model.w*x);
    if verboseOutput,
        objective = sum(log(sum(trueProb.*prob,1))) - param.lambda*sum(sum(model.w.^2));
        fprintf('Iter: %02i Objective: %f\n', iter, objective); 
    end
    delta = (trueProb - prob);
    gradL = delta*x';
    model.w = (1-param.eta*param.lambda)*model.w + param.eta*gradL;
end
model.classLabels = classLabels;

function sz = softmax(z)
sz = exp(z);
colsum = sum(sz, 1);
sz = sz*diag(1./colsum);