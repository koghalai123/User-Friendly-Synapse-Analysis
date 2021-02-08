%Not being used

close all;


%This uses the CoM of the ribbon groups to find the angle between that and
%the reticular lamina.

thetaMat=zeros(287,20);

dataStorageLocation='F:\RibbonAnalysisDataSets\Final';
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';

fileNum=37;
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
IHCStereociliaFile='ReticularLaminaPointsMatched.xlsx';
stereociliaTable=readtable(IHCStereociliaFile);
for i=1:3:34
    toSwitchVar=table2array(stereociliaTable(fileNum,i:i+2)).*voxelData;
    stereociliaMat(floor(i/3)+1,:)=toSwitchVar;
end

points=[stereociliaMat(10,:);stereociliaMat(11,:);stereociliaMat(12,:)];

% ptcloud=pointCloud(stereociliaMat(1:9,:));
% [model,meanError]=pcfitplane(ptcloud,100,'MaxNumTrials',100000);

F=scatteredInterpolant(stereociliaMat(1:9,1),stereociliaMat(1:9,2),stereociliaMat(1:9,3));

[X,Y]=meshgrid(0:100,20:70);

Z=F(X,Y);


% w = null(model.Normal);
% x=linspace(-100,100,100);
% y=linspace(-100,100,100);
%[P,Q]=meshgrid(x,y);

%z1=model.Parameters(1,4)/(-1*model.Parameters(1,3));
%syms X Y
%Z=-1*(model.Parameters(1,1)*X+model.Parameters(1,2)*Y+model.Parameters(1,4))/model.Parameters(1,3);
%ezmesh(Z);



numNuc=size(nucData,1);
opts = statset('Display','iter','MaxIter',10000);


%1 indicates pre, 2 indicates post
bothData=[preData(:,1:3),ones(size(preData,1),1);postData(:,1:3),2*ones(size(postData,1),1)];

alteredBothData=[preData(:,1),preData(:,2)/3,preData(:,3),ones(size(preData,1),1);postData(:,1),postData(:,2)/3,postData(:,3),2*ones(size(postData,1),1)];

[idxBoth,CBoth] = kmedoids(alteredBothData,numNuc,'PercentNeighbors',1);

% [idxPre,CPre] = kmedoids([preData(:,1),preData(:,2)/3,preData(:,3)],numNuc,'PercentNeighbors',1);
% [idxPost,CPost] = kmedoids([postData(:,1),postData(:,2)/3,postData(:,3)],numNuc,'PercentNeighbors',1);

fGrouped=figure('WindowState','fullscreen');
axesGrouped=axes(fGrouped);
hold(axesGrouped,'on');
%fVecs=figure();

% fManyPolarPre=figure();
% fManyPolarPost=figure();

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
    
    
    %set(0,'CurrentFigure',fGrouped);
    scatter3(axesGrouped,sortedNuc(i,1),sortedNuc(i,2),sortedNuc(i,3),2000,[r,g,b],'Marker','.')
    
    [row,~]=find(sortedBoth(i,1)==CBoth(:,1));
    validBoth=idxBoth==row;
    
    inGroup=bothData(validBoth,:);
    
    [rowPre,~]=find(inGroup(:,4)==1);
    [rowPost,~]=find(inGroup(:,4)==2);
    
%     preMat=inGroup(rowPre,:);
%     postMat=inGroup(rowPost,:);
%     
%     CoMPre=mean(preMat);
%     CoMPost=mean(postMat);
%     
%     stereociliaPoint=
%     thetaTemp=
    
    %     CoM=[mean([inGroup(rowPre,1);inGroup(rowPost,1)]),mean([inGroup(rowPre,2);inGroup(rowPost,2)]),mean([inGroup(rowPre,3);inGroup(rowPost,3)])];
    %
    %     b3x=CoM(1,1);
    %     b3y=(quadFit(1).*b3x.^2+quadFit(2).*b3x+quadFit(3));
    %     b3z=mean(points(1:3,3));
    %
    %     b1=fitlm(sortedNuc(:,1),sortedNuc(:,3)); %for rho
    %     b2=fitlm(sortedNuc(:,1),sortedNuc(:,2)); %for theta
    %
%     phiDiff=atan((CoM(1,3)-b3z)/(CoM(1,2)-b3y)); %vertical rotation about x axis
    %     thetaDiff=atan(table2array(b2.Coefficients(2,1)));  %horizontal rotation about z axis
    %     rhoDiff=atan(table2array(b1.Coefficients(2,1)));  %horizontal rotation about y axis
    scatter3(axesGrouped,inGroup(rowPre,1),inGroup(rowPre,2),inGroup(rowPre,3),10,[r,g,b],'Marker','*');
    scatter3(axesGrouped,inGroup(rowPost,1),inGroup(rowPost,2),inGroup(rowPost,3),10,[r,g,b],'Marker','o');
    %
    %
    %
    
%     vecPre=[inGroup(rowPre,1)-b3x,inGroup(rowPre,2)-b3y,inGroup(rowPre,3)-b3z];
%     vecPost=[inGroup(rowPost,1)-b3x,inGroup(rowPost,2)-b3y,inGroup(rowPost,3)-b3z];
%     
%     [azPre,elevPre,rPre]=cart2sph(vecPre(:,1),vecPre(:,2),vecPre(:,3));
%     [azPost,elevPost,rPost]=cart2sph(vecPost(:,1),vecPost(:,2),vecPost(:,3));
%     
%     [xPre,yPre,zPre]=sph2cart(azPre,elevPre-phiDiff,rPre);
%     [xPost,yPost,zPost]=sph2cart(azPost,elevPost-phiDiff,rPost);
%     
%     vecAdjPre=[vecAdjPre;xPre,yPre,zPre];
%     vecAdjPost=[vecAdjPost;xPost,yPost,zPost];
%     polarAdjPre=[polarAdjPre;azPre,elevPre-phiDiff,rPre];
%     polarAdjPost=[polarAdjPost;azPost,elevPost-phiDiff,rPost];
    
    %     set(0,'CurrentFigure',fVecs);
    %     rows=ceil(numNuc/5);
    %     subplot(rows,5,i)
    %     hold on;
    %     scatter(xPre,zPre,10,[1,0,0],'Marker','o');
    %     scatter(xPre,zPre,10,[0,1,0],'Marker','*');
    %     hold off;
    %
    %     set(0,'CurrentFigure',fManyPolarPre);
    %     rows=ceil(numNuc/5);
    %     subplot(rows,5,i,polaraxes)
    %     hold on;
    %     polarhistogram(rad2deg(azPre-thetaDiff),10);
    %     hold off;
    %
    %     set(0,'CurrentFigure',fManyPolarPost);
    %     rows=ceil(numNuc/5);
    %     subplot(rows,5,i,polaraxes)
    %     hold on;
    %     polarhistogram(rad2deg(azPost-thetaDiff),10);
    %     hold off;
    
end
quadFit1=polyfit(points(1:3,1),points(1:3,2),2);
x=linspace(fGrouped.CurrentAxes.XLim(1),fGrouped.CurrentAxes.XLim(2),1000);
y=quadFit1(1).*x.^2+quadFit1(2).*x+quadFit1(3);
quadFit2=polyfit(points(1:3,1),points(1:3,3),2);
z=quadFit2(1).*x.^2+quadFit2(2).*x+quadFit2(3);

plot3(axesGrouped,x,y,z)
scatter3(stereociliaMat(:,1),stereociliaMat(:,2),stereociliaMat(:,3),1000,[0,0,1],'Marker','+')
hold(axesGrouped,'off');
view(3);
%surf(X,Y,Z);
%fmesh(axesGrouped,Z);
