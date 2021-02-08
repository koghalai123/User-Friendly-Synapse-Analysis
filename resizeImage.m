function [resizedAllData,resizedDimensions,resizedVoxel]=resizeImage(allData,dimensions,voxel,X,Y)
% 
% function [resizedAllData,resizedDimensions,resizedVoxel]=resizeImage(allData,dimensions,voxel,X,Y)
% 
% Takes in an image and reduces the resolution for quicker graphing later
% on
% 
% resizedAllData is the intensity data as a 3D matrix
% resizedDimensions is the dimensions of the resized data
% resizedVoxel is the voxel sizes of the resized data
% 
% allData is the input intensity data as a matrix
% dimensions is the original size of the data
% voxel is the original size of a voxel
% X/Y is the size that it will be changed to. They need to be the same
% 

resizedAllData=zeros(X,Y,dimensions(3));
resizedDimensions=[X,Y,dimensions(3)];
resizedVoxel=[voxel(1)*dimensions(1)/X,voxel(2)*dimensions(2)/Y,voxel(3)];
for b = 1:size(allData,4)
    for i = 1:dimensions(3)
        resizedAllData(:,:,i,b)=imresize(allData(:,:,i,b),[X,Y]);

    end
end
end