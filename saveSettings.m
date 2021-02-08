%Saves settings when looking in 3d so that they can be pulled up later

function saveSettings(preCh,postCh,fileNum,Nfirst,NLast,NMin,NMax,NThresh,Rfirst,RLast,RMin,RMax,PreThresh,PostThresh)
matName=strcat(num2str(fileNum),'SettingsMat');
matValues=[preCh,postCh,Nfirst,NLast,NMin,NMax,NThresh,Rfirst,RLast,RMin,RMax,PreThresh,PostThresh];
save(matName,'matValues');
movefile(strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',matName,'.mat'),'F:\RibbonAnalysisDataSets\settings');

end