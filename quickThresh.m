function [allFiltered,newCenters,mu,ribbon,voxel,dimensions]=quickThresh(fileNum,RFirst,RLast,epsilon,rangeR,minGroup,threshMat,groupSize)
try
    [newCenters,mu]=retrieveNuclei(fileNum);
catch
    matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
    try
        
        storageLocation='F:\RibbonAnalysisDataSets\FinalDataNoCheck';
        DSName=strcat(num2str(fileNum),'FinalNoCheckData');
        DSString=strcat(storageLocation,'\',DSName);
        movefile(DSString,matlabPath);
        addpath(strcat(matlabPath,'\',DSName));
        load(strcat(num2str(fileNum),'FinalNoCheckOrigData.mat'));
        newCenters=saveInOrigForm{2, 1}(:,1:3);
        mu=saveInOrigForm{2, 1}(:,4);
        movefile(strcat(matlabPath,'\',DSName),storageLocation);
    catch
        
    end
end

fileName='FilteredData';
DSLocation='F:\RibbonAnalysisDataSets\FilteredData';
[allFiltered,voxel,dimensions,minMax]=loadTiff(fileNum,fileName,DSLocation);

if ~exist('newCenters','var')
    sensitivity=.976;
    radius=[60,100];
    range=[1,dimensions(1)];
    startValue=1;
    stopValue=0;
    [storeCenters,storeRadii]=viewPreliminaryData(allFiltered(:,:,:,1),range,sensitivity,stopValue,startValue,radius);
    %clusters them together and outputs the final nucleus centers and radii
    if size(storeCenters,1)==0
        storeCenters=[1,1,1];
        storeRadii=1;
    end
    [newCenters,mu,discardedN]=clusterNuclei(storeCenters,storeRadii,voxel);
    if size(newCenters,1)==0
        newCenters=[1,1,1];
        mu=1;
    end
    
end




ribbon=struct();
for i=1:2
[ribbon(i).points,ribbon(i).grouped]=findRib(allFiltered(:,:,:,i+1),[newCenters,mu],threshMat(i),dimensions,voxel,RFirst,RLast,epsilon,rangeR,minGroup,groupSize(i));


end
