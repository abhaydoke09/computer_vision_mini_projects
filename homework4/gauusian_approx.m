
sigma = 2;
N = 5;

[x,y]=meshgrid(-floor(N/2) : floor(N/2),-floor(N/2) : floor(N/2));

Exp_comp = -(x.^2+y.^2)/(2*sigma*sigma);
Kernel= exp(Exp_comp)/(2*pi*sigma*sigma)
%size(Kernel);

%A = [1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1];
%B = [1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1];
A = ones(N);
B = ones(N);

x = ones(20,1);
kernals = zeros(N,N,20);
for i = 1:20
   A = imfilter(A,B);
   A = A./(N*N);
 
   d = sum(sum((A-Kernel).^2));
   x(i) = d;
   kernals(:,:,i) = A;
   A
   d
  
end
y = linspace(0,50,50);
[M,I] = min(x);

disp(kernals(:,:,I));
plot(x);
xlabel('Iteration');
ylabel('Error');
title('Error between gauusian filter(sigma=2) and constant filter of 5X5')
saveas(gcf,'Error5.png')