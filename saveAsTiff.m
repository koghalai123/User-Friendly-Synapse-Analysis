function []=saveAsTiff(allData,folderName,dataFile,storageLocation,voxel,dimensions,minMax)
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';


mkdir(folderName)
for j=1:size(allData,4)
    fileName=strcat(num2str(dataFile),'C',num2str(j),'.tif');
    imwrite(im2uint8(allData(:,:,1,j)),fileName);
    for k =2:size(allData,3)


        imwrite(im2uint8(allData(:,:,k,j)),fileName,'WriteMode','append');

    end
    movefile(fileName,folderName);
end

if exist('voxel','var')
    settingsData=struct;
    settingsData.voxel=voxel;
    settingsData.dimensions=dimensions;
    settingsData.minMax=minMax;
    settingsFile=strcat(num2str(dataFile),'Settings.mat');
    save(settingsFile,'settingsData');
    movefile(settingsFile,folderName);
end


MDString=strcat(matlabPath,'\',folderName);
movefile(MDString,storageLocation);
