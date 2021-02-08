%not being used

close all;


%This uses the CoM iof the ribbon groups instead of the nuclei

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

fGrouped=figure();
axesGrouped=axes(fGrouped);
hold(axesGrouped,'on');

fVecs=figure();

fManyPolarPre=figure();
fManyPolarPost=figure();

sortedBoth=sortrows(CBoth,1);
sortedNuc=sortrows(nucData,1);

vecAdjPre=[];
vecAdjPost=[];
polarAdjPre=[];
polarAdjPost=[];

for i=1:numNuc
    
    r=rand;
    g=rand;
    b=rand;
    
    
    set(0,'CurrentFigure',fGrouped);
    scatter3(axesGrouped,sortedNuc(i,1),sortedNuc(i,2),sortedNuc(i,3),2000,[r,g,b],'Marker','.')
    
    [row,~]=find(sortedBoth(i,1)==CBoth(:,1));
    validBoth=idxBoth==row;
    
    inGroup=bothData(validBoth,:);
    
    [rowPre,~]=find(inGroup(:,4)==1);
    [rowPost,~]=find(inGroup(:,4)==2);
    
    quadFit=polyfit(points(1:3,1),points(1:3,2),2);
    x=linspace(fGrouped.CurrentAxes.XLim(1),fGrouped.CurrentAxes.XLim(2),1000);
    y=quadFit(1).*x.^2+quadFit(2).*x+quadFit(3);
    z=mean(points(1:3,3)).*ones(1000,1);
    plot3(axesGrouped,x,y,z)
    
    CoM=[mean([inGroup(rowPre,1);inGroup(rowPost,1)]),mean([inGroup(rowPre,2);inGroup(rowPost,2)]),mean([inGroup(rowPre,3);inGroup(rowPost,3)])];
    
    b3x=CoM(1,1);
    b3y=(quadFit(1).*b3x.^2+quadFit(2).*b3x+quadFit(3));
    b3z=mean(points(1:3,3));
%     
%     b1=fitlm(sortedNuc(:,1),sortedNuc(:,3)); %for rho
%     b2=fitlm(sortedNuc(:,1),sortedNuc(:,2)); %for theta
%     
     phiDiff=atan((CoM(1,3)-b3z)/(CoM(1,2)-b3y)); %vertical rotation about x axis
%     thetaDiff=atan(table2array(b2.Coefficients(2,1)));  %horizontal rotation about z axis
%     rhoDiff=atan(table2array(b1.Coefficients(2,1)));  %horizontal rotation about y axis
    scatter3(axesGrouped,inGroup(rowPre,1),inGroup(rowPre,2),inGroup(rowPre,3),10,[r,g,b],'Marker','*');
    scatter3(axesGrouped,inGroup(rowPost,1),inGroup(rowPost,2),inGroup(rowPost,3),10,[r,g,b],'Marker','o');
    %
    %
    %
    
    vecPre=[inGroup(rowPre,1)-b3x,inGroup(rowPre,2)-b3y,inGroup(rowPre,3)-b3z];
    vecPost=[inGroup(rowPost,1)-b3x,inGroup(rowPost,2)-b3y,inGroup(rowPost,3)-b3z];
    
    [azPre,elevPre,rPre]=cart2sph(vecPre(:,1),vecPre(:,2),vecPre(:,3));
    [azPost,elevPost,rPost]=cart2sph(vecPost(:,1),vecPost(:,2),vecPost(:,3));
    
    [xPre,yPre,zPre]=sph2cart(azPre,elevPre-phiDiff,rPre);
    [xPost,yPost,zPost]=sph2cart(azPost,elevPost-phiDiff,rPost);
    
    vecAdjPre=[vecAdjPre;xPre,yPre,zPre];
    vecAdjPost=[vecAdjPost;xPost,yPost,zPost];
    polarAdjPre=[polarAdjPre;azPre,elevPre-phiDiff,rPre];
    polarAdjPost=[polarAdjPost;azPost,elevPost-phiDiff,rPost];
    
    set(0,'CurrentFigure',fVecs);
    rows=ceil(numNuc/5);
    subplot(rows,5,i)
    hold on;
    scatter(xPre,zPre,10,[1,0,0],'Marker','o');
    scatter(xPre,zPre,10,[0,1,0],'Marker','*');
    hold off;
    
    set(0,'CurrentFigure',fManyPolarPre);
    rows=ceil(numNuc/5);
    subplot(rows,5,i,polaraxes)
    hold on;
    polarhistogram(rad2deg(azPre-thetaDiff),10);
    hold off;
    
    set(0,'CurrentFigure',fManyPolarPost);
    rows=ceil(numNuc/5);
    subplot(rows,5,i,polaraxes)
    hold on;
    polarhistogram(rad2deg(azPost-thetaDiff),10);
    hold off;
    
end
view(axesGrouped,3);
hold off;
fVecPlot=figure;
axesVecPlot=axes(fVecPlot);
hold on;
scatter3(axesVecPlot,vecAdjPre(:,1),vecAdjPre(:,2),vecAdjPre(:,3),10,[1,0,0],'Marker','*');
scatter3(axesVecPlot,vecAdjPost(:,1),vecAdjPost(:,2),vecAdjPost(:,3),10,[0,1,0],'Marker','o');
scatter3(axesVecPlot,0,0,0,2000,[0,0,0],'Marker','.');
view(3);
hold off;

fPolarPlot=figure;

axesPolarPlot1=polaraxes(fPolarPlot,'OuterPosition',[0,0,.5,1]);
axesPolarPlot2=polaraxes(fPolarPlot,'OuterPosition',[.5,0,.5,1]);

p1=polarhistogram(axesPolarPlot1,rad2deg(polarAdjPre(:,1)),15);
p2=polarhistogram(axesPolarPlot2,rad2deg(polarAdjPost(:,1)),15);


% plot3(x,y,z)

