%finds the nuclei from previous checking of data

function [newCenters,mu]=retrieveNuclei(DSNum)



storageLocation='F:\RibbonAnalysisDataSets\PreliminaryData';
folderName=strcat(num2str(DSNum),'FinalData');
movefile(strcat(storageLocation,'\',folderName));

addpath(folderName);

fileName=strcat(num2str(DSNum),'FinalOrigData.mat');
load(fileName);

nucData=saveInOrigForm{2, 1};
newCenters=nucData(:,1:3);
mu=nucData(:,4);

movefile(folderName,storageLocation);

end