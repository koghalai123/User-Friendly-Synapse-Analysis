

function [plainData,minMax,dimensions]=loadMiniData(fileNum)
miniDataName=strcat(num2str(fileNum),'Mini.mat');
movefile(strcat('F:\RibbonAnalysisDataSets\MiniData\',miniDataName),'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');
MD=open(miniDataName);
plainData=MD.allData;
movefile(strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',miniDataName),'F:\RibbonAnalysisDataSets\MiniData');
minMax=zeros(4,2);
minMax(:,2)=65535;
dimensions=size(plainData);
end