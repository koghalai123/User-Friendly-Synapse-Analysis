dataFile=3;
DSLocation='F:\RibbonAnalysisDataSets\tiffData';

fileName=strcat(num2str(dataFile),'C',num2str(1),'.tif');
folderName=strcat(num2str(dataFile),'RawData');

matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
storageLocationMD=DSLocation;
MDString=strcat(storageLocationMD,'\',folderName);
movefile(MDString,matlabPath);
addpath(folderName);

fileName=strcat(num2str(dataFile),'C4.tif');

info = imfinfo(fileName);
stackHeight=size(info,1);
row=info(1).Height;
col=info(1).Width;
phalloidenData=zeros(row,col,stackHeight,1,'uint8');

for j = 1:stackHeight
    phalloidenData(:,:,j)=(imread(fileName,j));
end

movefile(folderName,DSLocation);

volshow(phalloidenData);