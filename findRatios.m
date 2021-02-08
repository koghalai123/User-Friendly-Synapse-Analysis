%Script that takes the data and creates reatios out of it. This was used to
%add to an excel file


dataStorageLocation='F:\RibbonAnalysisDataSets\Final';
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';

ratioMat=[];
for i=1:287
    try
        fileNum=i;
        folderName=strcat(num2str(fileNum),'Final');
        movefile(strcat(dataStorageLocation,'\',folderName),matlabPath);
        addpath(folderName);

        nucFileName=strcat(num2str(fileNum),'FinalNuc.xlsx');
        nucData=table2array(readtable(nucFileName));
        preFileName=strcat(num2str(fileNum),'FinalPre.xlsx');
        preData=table2array(readtable(preFileName));
        postFileName=strcat(num2str(fileNum),'FinalPost.xlsx');
        postData=table2array(readtable(postFileName));
        movefile(folderName,dataStorageLocation);

        numNuc=size(nucData,1);
        preRatio=size(preData,1)/numNuc;
        postRatio=size(postData,1)/numNuc;
        
        ratioMat(i,1)=numNuc;
        ratioMat(i,2)=preRatio;
        ratioMat(i,3)=postRatio;
        
    catch
        
    end
end

