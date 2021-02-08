%not being used

dataFile=6;
storageLocationDS='F:\RibbonAnalysisDataSets\BlindedData';
storageLocationResults='F:\RibbonAnalysisDataSets\FinalDataNoCheck11-27-20';
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
resultsName='FinalNoCheck';




addPathResults=strcat(storageLocationResults, '\',num2str(dataFile),resultsName,'Data');
movefile(addPathResults,matlabPath);
varFolder=strcat(matlabPath,'\',num2str(dataFile),resultsName,'Data');
addpath(varFolder);
varFile=strcat(num2str(dataFile),resultsName,'OrigData.mat');
load(varFile);



addPathString=strcat(storageLocationDS,'\',num2str(dataFile),'.czi');
movefile(addPathString,matlabPath);



dataFileName=strcat(num2str(dataFile),'.czi');

[voxel,dimensions,minMax,allData]=initialize(dataFileName,1,2,3,4);

rmPathString=strcat(matlabPath,'\',num2str(dataFile),'.czi');
rmPathResults=strcat(matlabPath,'\',num2str(dataFile),resultsName,'Data');
movefile(rmPathString,storageLocationDS);
movefile(rmPathResults,storageLocationResults);


newCenters=saveInOrigForm{2, 1}(:,1:3);
mu=saveInOrigForm{2, 1}(:,4);
ribbon=saveInOrigForm{2, 9};
[sendPre,sendPost]=ClusteredToSlice(ribbon,dimensions);

presynaptic=saveInOrigForm{2, 10};  
postsynaptic=saveInOrigForm{2, 11};  


f=figure();
[f,objHandles]=setXYLimits(newCenters,mu,ribbon,dimensions,voxel,f,0);


loadInLimits=uicontrol(f,'Style','pushbutton','String','Load in limits','Position',[10,330,100,30],'Callback',{@loadInLimitData,f,dataFile,objHandles});
saveRibbonSliceBut=uicontrol(f,'Style','pushbutton','Position',[10,270,100,30],'String','Save Limits','Callback',{@saveRibbonSlice,f,dataFile});

RFirst=1;
RLast=1;
epsilon=4;
rangeR=[1,dimensions(2)];
minGroup=12;
threshMat=table2array(dataSettings(fileNum,10:11));
groupSize=[4,3];
[allFiltered,newCenters,mu,ribbon,voxel,~]=quickThresh(dataFile,RFirst,RLast,epsilon,rangeR,minGroup,threshMat,groupSize);


tiffData=struct();
tiffData.fileNum=dataFile;
tiffData.allFiltered=allFiltered;
tiffData.epsilon=epsilon;
tiffData.rangeR=rangeR;
tiffData.minGroup=minGroup;
tiffData.groupSize=groupSize;
tiffData.thresholds=threshMat;



function saveRibbonSlice(~,~,f,dataFile)
nucLims=f.UserData(1).NucLimits;
ribLims=f.UserData(1).RibLimits;
lims=struct();
lims.nucLims=nucLims;
lims.ribLims=ribLims;
limFN=strcat(num2str(dataFile),'YZLims');
save(limFN,'lims');
end
function loadInLimitData(~,~,f,dataFile,objHandles)
limitDataName=strcat(num2str(dataFile),'YZLims.mat');
movefile(strcat('F:\RibbonAnalysisDataSets\LimitData\',limitDataName),'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');
load(limitDataName);
movefile(strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',limitDataName),'F:\RibbonAnalysisDataSets\LimitData');

minNucYBut=findobj(f.Children,'Position',[0,0,200,20]);
maxNucYBut=findobj(f.Children,'Position',[0,20,200,20]);
minNucZBut=findobj(f.Children,'Position',[0,40,200,20]);
maxNucZBut=findobj(f.Children,'Position',[0,60,200,20]);


minRibYBut=findobj(f.Children,'Position',[0,100,200,20]);
maxRibYBut=findobj(f.Children,'Position',[0,120,200,20]);
minRibZBut=findobj(f.Children,'Position',[0,140,200,20]);
maxRibZBut=findobj(f.Children,'Position',[0,160,200,20]);


minNucYBut.Value=lims.nucLims(1,1);
maxNucYBut.Value=lims.nucLims(1,2);
minNucZBut.Value=lims.nucLims(2,1);
maxNucZBut.Value=lims.nucLims(2,2);

minRibYBut.Value=lims.ribLims(1,1);
maxRibYBut.Value=lims.ribLims(1,2);
minRibZBut.Value=lims.ribLims(2,1);
maxRibZBut.Value=lims.ribLims(2,2);

xMax=(objHandles(1,1).XData(1,2));

plotLines([],[],objHandles(1,1),objHandles(1,2),objHandles(1,3),objHandles(1,4),minNucYBut,maxNucYBut,minNucZBut,maxNucZBut,xMax);
plotLines([],[],objHandles(2,1),objHandles(2,2),objHandles(2,3),objHandles(2,4),minRibYBut,maxRibYBut,minRibZBut,maxRibZBut,xMax);

end
function plotLines(~,~,line1,line2,line3,line4,minYBut,maxYBut,minZBut,maxZBut,xMax)
minY=minYBut.Value;
maxY=maxYBut.Value;
minZ=minZBut.Value;
maxZ=maxZBut.Value;


line1.YData=[minY,minY];
line1.ZData=[minZ,minZ];
line1.XData=[1,xMax];

line2.YData=[maxY,maxY];
line2.ZData=[minZ,minZ];
line2.XData=[1,xMax];


line3.YData=[minY,minY];
line3.ZData=[maxZ,maxZ];
line3.XData=[1,xMax];

line4.YData=[maxY,maxY];
line4.ZData=[maxZ,maxZ];
line4.XData=[1,xMax];


end


