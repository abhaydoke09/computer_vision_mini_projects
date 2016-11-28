x = linspace(0,1,100);
y = linspace(0,1,100);
[X,Y] = meshgrid(x,y);
F = X.*Y-0.04.*((X+Y).^2);
F1 = 2./((1./X)+(1./Y))+0.04; % New function which 





 % surf(X,Y,F)
%  title('f (\lambda1,\lambda2)  =  \lambda1\lambda2 - \alpha(\lambda1 + \lambda2)^2');
surf(X,Y,F1)
title('f (\lambda1,\lambda2)  =  2/((1/\lambda1)+(1/\lambda2)) + \alpha');
xlabel('\lambda1');
ylabel('\lambda2');
zlabel('f (\lambda1,\lambda2)');
colormap jet