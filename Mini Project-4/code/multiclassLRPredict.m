function ypred = multiclassLRPredict(model,x)

% Add a bias term
x = cat(1, x, ones(1, size(x,2)));
prob = softmax(model.w*x);
[~,maxId] = max(prob);
ypred = model.classLabels(maxId);

function sz = softmax(z)
sz = exp(z);
colsum = sum(sz, 1);
sz = sz*diag(1./colsum);