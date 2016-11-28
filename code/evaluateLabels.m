function [acc, conf] = evaluateLabels(y, ypred, visualize)
classLabels = unique(y);
conf = zeros(length(classLabels));
for tc = 1:length(classLabels)
    for pc = 1:length(classLabels)
        conf(tc,pc) = sum(y==classLabels(tc) & ypred==classLabels(pc));
    end
end
acc = sum(diag(conf))/length(y);

% If visualize is set to true then display the confusion matrix
if nargin < 3, visualize=false; end;
if visualize,
    figure;
    imagesc(conf); colormap gray; axis image;
    set(gca, 'xticklabel',{classLabels});
    set(gca, 'yticklabel',{classLabels});
    ylabel('true labels', 'FontSize',24);
    xlabel('predicted labels','FontSize',24);
end    