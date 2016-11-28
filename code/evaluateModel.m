function y = evaluateModel(model, x)
% EVALUATEMODEL evaluates the model
%   Y = EVALUATEMODEL(MODEL, X) evaluates the MODEL on the set X. The
%   output is the vector of the same length as the number of examples in X
%   which indicates the class label of each instance. Currently only
%   multiclass logistic regression models are supported.

y = multiclassLRPredict(model, x);
