%Not used

dataStorageLocation='F:\RibbonAnalysisDataSets\Final';
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';

fileNum=2;
folderName=strcat(num2str(fileNum),'Final');
movefile(strcat(dataStorageLocation,'\',folderName),matlabPath);
addpath(folderName);

nucFileName=strcat(num2str(fileNum),'FinalNuc.xlsx');
nucData=table2array(readtable(nucFileName));
preFileName=strcat(num2str(fileNum),'FinalPre.xlsx');
preData=table2array(readtable(preFileName));
postFileName=strcat(num2str(fileNum),'FinalPost.xlsx');
postData=table2array(readtable(postFileName));
load(strcat(num2str(fileNum),'FinalMat.mat'));
movefile(folderName,dataStorageLocation);

voxelData=saveInOrigForm{2, 4};
IHCStereociliaFile='StereociliaPointsMatched.xlsx';
sterociliaTable=readtable(IHCStereociliaFile);
sterociliaMat=[table2array(sterociliaTable(:,1:3)).*voxelData,table2array(sterociliaTable(:,4:6)).*voxelData,table2array(sterociliaTable(:,7:9)).*voxelData];
IHCSterociliaMat=sterociliaMat(fileNum,:);
points=[IHCSterociliaMat(1:3);IHCSterociliaMat(4:6);IHCSterociliaMat(7:9)];


numNuc=size(nucData,1);
opts = statset('Display','iter','MaxIter',10000);


%1 indicates pre, 2 indicates post
bothData=[preData(:,1:3),ones(size(preData,1),1);postData(:,1:3),2*ones(size(postData,1),1)];

alteredBothData=[preData(:,1),preData(:,2)/3,preData(:,3),ones(size(preData,1),1);postData(:,1),postData(:,2)/3,postData(:,3),2*ones(size(postData,1),1)];

[idxBoth,CBoth] = kmedoids(alteredBothData,numNuc,'PercentNeighbors',1);

% [idxPre,CPre] = kmedoids([preData(:,1),preData(:,2)/3,preData(:,3)],numNuc,'PercentNeighbors',1);
% [idxPost,CPost] = kmedoids([postData(:,1),postData(:,2)/3,postData(:,3)],numNuc,'PercentNeighbors',1);


f=figure;
hold on;
sortedBoth=sortrows(CBoth,1);
sortedNuc=sortrows(nucData,1);

for i=1:numNuc
    r=rand;
    g=rand;
    b=rand;
    
    
    scatter3(sortedNuc(i,1),sortedNuc(i,2),sortedNuc(i,3),2000,[r,g,b],'Marker','.')
    
    [row,~]=find(sortedBoth(i,1)==CBoth(:,1));
    validBoth=idxBoth==row;
    
    inGroup=bothData(validBoth,:);
    
    [rowPre,~]=find(inGroup(:,4)==1);
    [rowPost,~]=find(inGroup(:,4)==2);
    
    
    scatter3(inGroup(rowPre,1),inGroup(rowPre,2),inGroup(rowPre,3),10,[r,g,b],'Marker','*');
    scatter3(inGroup(rowPost,1),inGroup(rowPost,2),inGroup(rowPost,3),10,[r,g,b],'Marker','o');
    
    
    view(3);
    
    
end


quadFit=polyfit(points(1:3,1),points(1:3,2),2);
x=linspace(f.CurrentAxes.XLim(1),f.CurrentAxes.XLim(2),1000);
y=quadFit(1).*x.^2+quadFit(2).*x+quadFit(3);
z=mean(points(1:3,3)).*ones(1000,1);
plot3(x,y,z)
hold off;
