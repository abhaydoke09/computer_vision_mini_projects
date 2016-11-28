function  heightMap = getSurface(surfaceNormals, method)
% GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object
[h,w,n] = size(surfaceNormals);
heightMap = zeros([h w]);
gxy = zeros([h w]);
gxx = zeros([h w]);

gxx = surfaceNormals(:,:,2)./surfaceNormals(:,:,3);
gxy = surfaceNormals(:,:,1)./surfaceNormals(:,:,3);
switch method
    case 'column'
        %% implement this %%%
        for i = 1:h
            for j = 1:w
                sum = 0;
                for x = 1:i
                    sum = sum + gxx(x,1);
                end
                for y = 2:j
                    sum = sum+gxy(i,y);
                end
                
                heightMap(i,j) = sum;
            end
         end
                          
    case 'row'
        %%% implement this %%%
        for i = 1:h
            for j = 1:w
                sum = 0;
                for y = 1:j
                    sum = sum + gxy(1,y);
                end
                for x = 2:i
                    sum = sum + gxx(x,j);
                end
                heightMap(i,j) = sum;
            end
         end

    case 'average'
        %%% implement this %%%
        for i = 1:h
            for j = 1:w
                sum1 = 0;
                for y = 1:j
                    sum1 = sum1 + gxy(1,y);
                end
                for x = 2:i
                    sum1 = sum1 + gxx(x,j);
                end
        
                
                sum2 = 0;
                for x = 1:i
                    sum2 = sum2 + gxx(x,1);
                end
                for y = 2:j
                    sum2 = sum2 + gxy(i,y);
                end
                
                heightMap(i,j) = (sum1+sum2)/2.0;
            end
        end
        
        
    case 'random'
        %%% implement this %%%
        for i = 1:h
            for j = 1:w
                x=1;
                y=1;
                sum = 0;
                while(x<i & y<j)
                    sum = sum+gxx(x,y);
                    
                    y=y+1;
                    if y<j
                        sum=sum+gxy(x,y);
                        
                    else
                        break;
                    end
                    x=x+1;
                    if x<i
                        sum=sum+gxx(x,y);
                        
                    else
                    end
                end
                if y==j & x<i
                    for a=x:i
                        sum = sum+gxx(a,y);
                        
                    end
                elseif x==i & y<j
                    for a=y:j
                        sum=sum+gxy(x,a);
                        
                    end
                else
                    sum = sum+gxx(x,y);
                    
                end
                
                heightMap(i,j)=sum;
            end
        end      
end

