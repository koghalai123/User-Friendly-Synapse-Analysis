
function [allData,voxel,dimensions,minMax]=loadTiff(dataFile,fileName,DSLocation)


folderName=strcat(num2str(dataFile),fileName);
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
storageLocationMD=DSLocation;
MDString=strcat(storageLocationMD,'\',folderName);
movefile(MDString,matlabPath);
addpath(folderName);


fileName=strcat(num2str(dataFile),'C',num2str(1),'.tif');
info = imfinfo(fileName);
stackHeight=size(info,1);
row=info(1).Height;
col=info(1).Width;
allData=zeros(row,col,stackHeight,4,'uint16');
for i=1:4
    
    fileName=strcat(num2str(dataFile),'C',num2str(i),'.tif');
    
    for j = 1:stackHeight
        allData(:,:,j,i)=im2uint16(imread(fileName,j));
    end
end

settingsFile=strcat(num2str(dataFile),'Settings.mat');
load(settingsFile);
voxel=settingsData.voxel;
dimensions=settingsData.dimensions;
minMax=settingsData.minMax;
movefile(folderName,storageLocationMD)
end