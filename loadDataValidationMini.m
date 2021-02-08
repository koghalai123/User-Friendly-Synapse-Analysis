%Not being used

f=figure();
newCenters=[1,1,1];
mu=[1];
ribbon=struct([]);
ribbon(1).grouped=[1,1,1];
ribbon(2).grouped=[1,1,1];
dimensions=[1,1,1];
voxel=[1,1,1];
dataFile=[];

[f,objHandles]=setXYLimits(newCenters,mu,ribbon,dimensions,voxel,f,1);

newDataSetInput=uicontrol('Style','edit','Position',[10,300,80,30]);
loadNewDataSet=uicontrol('Style','pushbutton','String','Load in this data set','Callback',{@loadInSet,f,newDataSetInput},'Position',[90,300,100,30]);
saveRibbonSliceBut=uicontrol(f,'Style','pushbutton','Position',[10,270,100,30],'String','Save Limits','Callback',{@saveRibbonSlice,f,dataFile});
viewRibbons=uicontrol(f,'Style','pushbutton','String','Graph the middle slice','Position',[10,360,100,30],'Callback',{@viewMiddleRibbonSlice,f,dataFile,dimensions});
loadInLimits=uicontrol(f,'Style','pushbutton','String','Load in limits','Position',[10,330,100,30],'Callback',{@loadInLimitData,f,dataFile,objHandles});
viewNuclei=uicontrol(f,'Style','pushbutton','String','View Nuclei','Position',[10,390,100,30],'Callback',{@viewNuclei3D,f,dataFile,voxel,dimensions});


function saveRibbonSlice(~,~,f,dataFile)
nucLims=f.UserData(1).NucLimits;
ribLims=f.UserData(1).RibLimits;
lims=struct();
lims.nucLims=nucLims;
lims.ribLims=ribLims;
limFN=strcat(num2str(dataFile),'YZLims');
save(limFN,'lims');
end
function loadInSet(~,~,f,newDataSetInput)

dataFile=str2double(newDataSetInput.String);
storageLocationDS='F:\RibbonAnalysisDataSets\BlindedData';
storageLocationResults='F:\RibbonAnalysisDataSets\BlindedResultsThresh24';
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
resultsName='BothAuto';


delete(f.Children);
delete(f.CurrentAxes);
f.UserData=[];

addPathResults=strcat(storageLocationResults, '\',num2str(dataFile),resultsName,'Data');
movefile(addPathResults,matlabPath);
varFolder=strcat(matlabPath,'\',num2str(dataFile),resultsName,'Data');
addpath(varFolder);
varFile=strcat(num2str(dataFile),resultsName,'OrigData.mat');
load(varFile,'saveInOrigForm');

dimensions=saveInOrigForm{2, 12};
voxel=saveInOrigForm{2, 13};
newCenters=saveInOrigForm{2, 1}(:,1:3);
mu=saveInOrigForm{2, 1}(:,4);
ribbon=saveInOrigForm{2, 9};


presynaptic=saveInOrigForm{2, 10};  
postsynaptic=saveInOrigForm{2, 11};  


rmPathResults=strcat(matlabPath,'\',num2str(dataFile),resultsName,'Data');
movefile(rmPathResults,storageLocationResults);

newDataSetInput=uicontrol('Style','edit','Position',[10,300,80,30],'String',num2str(dataFile));
loadNewDataSet=uicontrol('Style','pushbutton','String','Load in this data set','Callback',{@loadInSet,f,newDataSetInput},'Position',[90,300,100,30]);
viewRibbons=uicontrol(f,'Style','pushbutton','String','Graph the middle slice','Position',[10,360,100,30],'Callback',{@viewMiddleRibbonSlice,f,dataFile,dimensions});


saveRibbonSliceBut=uicontrol(f,'Style','pushbutton','Position',[10,270,100,30],'String','Save Limits','Callback',{@saveRibbonSlice,f,dataFile});
[f,objHandles]=setXYLimits(newCenters,mu,ribbon,dimensions,voxel,f,0);
loadInLimits=uicontrol(f,'Style','pushbutton','String','Load in limits','Position',[10,330,100,30],'Callback',{@loadInLimitData,f,dataFile,objHandles});
viewNuclei=uicontrol(f,'Style','pushbutton','String','View Nuclei','Position',[10,390,100,30],'Callback',{@viewNuclei3D,f,dataFile,voxel,dimensions});


end
function viewNuclei3D(~,~,f,dataFile,voxel,dimensions)

    
    
appStruct=dataObj;
nucData=f.UserData(1).Nucleus;
preStruct=f.UserData(1).Ribbon;
postStruct=f.UserData(2).Ribbon;
chooseOrgCha=1;
imageSize=500;


miniAllDataName=strcat(num2str(dataFile),'Mini.mat');
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
movefile(strcat('F:\RibbonAnalysisDataSets\MiniData500x500\',miniAllDataName),matlabPath);
miniData=open(miniAllDataName);
movefile(strcat(matlabPath,'\',miniAllDataName),'F:\RibbonAnalysisDataSets\MiniData500x500');
tempData=miniData.allData;
tempResizedDimensions=size(tempData);
for b = 1:2
    allData(:,:,:,b)=imresize3(tempData(:,:,:,b),[500,500,3*tempResizedDimensions(3)]);
end
resultsName='BothAuto';
storageLocationResults='F:\RibbonAnalysisDataSets\BlindedResultsThresh24';
addPathResults=strcat(storageLocationResults, '\',num2str(dataFile),resultsName,'Data');
movefile(addPathResults,matlabPath);
varFolder=strcat(matlabPath,'\',num2str(dataFile),resultsName,'Data');
addpath(varFolder);
varFile=strcat(num2str(dataFile),resultsName,'OrigData.mat');
load(varFile,'saveInOrigForm');
movefile(strcat(matlabPath,'\',num2str(dataFile),resultsName,'Data'),storageLocationResults);
presynaptic=saveInOrigForm{2, 10};  
postsynaptic=saveInOrigForm{2, 11};  

channelVec=[1,presynaptic,postsynaptic,4];
resizedDimensions=size(allData);
resizedVoxel=voxel.*dimensions./resizedDimensions(1:3);

appDataStruct=struct([]);
appDataStruct(1).grouped=preStruct;
appDataStruct(2).grouped=postStruct;
appStruct.UserData=appDataStruct;
appStruct.newCenters=nucData(:,1:3);
appStruct.mu=nucData(:,4);
appStruct.fileNum=dataFile;
appStruct.presynaptic=presynaptic;
appStruct.postsynaptic=postsynaptic;
appStruct.voxel=voxel;
appStruct.dimensions=dimensions;

checkData3D(appStruct,allData,chooseOrgCha,nucData,preStruct,postStruct,imageSize,channelVec,[],resizedVoxel,resizedDimensions(1:3),1)





end
function viewMiddleRibbonSlice(~,~,f,dataFile,dimensions)
ribbon=struct([]);
ribbon(1).grouped=f.UserData(1).Ribbon;
ribbon(2).grouped=f.UserData(2).Ribbon;

[sendPre,sendPost]=ClusteredToSlice(ribbon,dimensions);

limDataSetName=strcat(num2str(dataFile),'LimMiniData.mat');
movefile(strcat('F:\RibbonAnalysisDataSets\MiniData2048x2048\',limDataSetName),'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');
loadedData=open(limDataSetName);
allData=loadedData.allData;

limitDataName=strcat(num2str(dataFile),'YZLims.mat');
movefile(strcat('F:\RibbonAnalysisDataSets\LimitData\',limitDataName),'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');
load(limitDataName);
movefile(strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',limitDataName),'F:\RibbonAnalysisDataSets\LimitData');
ZLims=lims.ribLims(2,:);

slice = round((ZLims(2)+ZLims(1))/2);
for b = 1:2
    scaled=rescale(allData(:,:,1,b));
    [brightnessAdjusted]=changeBrightness(.25,scaled);
    [contrastAdjusted]=changeContrast(.3,brightnessAdjusted);
    adjData(:,:,1,b)=contrastAdjusted;
end

fPresynaptic=figure('Name','Presynaptic');
aPresynaptic=axes(fPresynaptic);
imshow(adjData(:,:,1,1),[],'Parent',aPresynaptic);
hold(aPresynaptic,'on');
scatter(aPresynaptic,sendPre(slice).points(:,1),sendPre(slice).points(:,2),15,[1,0,0]);
hold(aPresynaptic,'off');


fPostsynaptic=figure('Name','Postsynaptic');
aPostsynaptic=axes(fPostsynaptic);
hold(aPostsynaptic,'on');
imshow(adjData(:,:,1,2),[],'Parent',aPostsynaptic);
scatter(aPostsynaptic,sendPost(slice).points(:,1),sendPost(slice).points(:,2),15,[1,0,0]);
hold(aPostsynaptic,'off');

movefile(strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',limDataSetName),'F:\RibbonAnalysisDataSets\MiniData2048x2048');
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

