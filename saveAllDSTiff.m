%Saves each dataset as a tiff to make opening it easier

function [voxel,dimensions,minMax,allData]=saveAllDSTiff(i)
    
    dataFile=i;
    storageLocationDS='F:\RibbonAnalysisDataSets\BlindedData';
    matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
    resultsName='FinalNoCheck';
    addPathString=strcat(storageLocationDS,'\',num2str(dataFile),'.czi');
    movefile(addPathString,matlabPath);
    dataFileName=strcat(num2str(dataFile),'.czi');
    [voxel,dimensions,minMax,allData]=initialize(dataFileName,1,2,3,4);
    
    folderName=strcat(num2str(i),'RawData');
    storageLocationMD='F:\RibbonAnalysisDataSets\tiffData';
    saveAsTiff(allData,folderName,dataFile,storageLocationMD,voxel,dimensions,minMax)
    
    rmPathString=strcat(matlabPath,'\',num2str(dataFile),'.czi');
    movefile(rmPathString,storageLocationDS);
   
end