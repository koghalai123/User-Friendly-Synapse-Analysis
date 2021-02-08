%not used

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
movefile(folderName,dataStorageLocation);



numNuc=size(nucData,1);
opts = statset('Display','iter','MaxIter',10000);


[idxPre,CPre] = kmedoids([preData(:,1),preData(:,2)/3,preData(:,3)],numNuc,'PercentNeighbors',1);
[idxPost,CPost] = kmedoids([postData(:,1),postData(:,2)/3,postData(:,3)],numNuc,'PercentNeighbors',1);


f=figure;
hold on;
sortedPost=sortrows(CPost,1);
sortedPre=sortrows(CPre,1);
sortedNuc=sortrows(nucData,1);

for i=1:numNuc
    r=rand;
    g=rand;
    b=rand;
    
    
    scatter3(sortedNuc(i,1),sortedNuc(i,2),sortedNuc(i,3),2000,[r,g,b],'Marker','.')
    
    [row,~]=find(sortedPre(i,1)==CPre(:,1));
    validPre=idxPre==row;
    scatter3(preData(validPre,1),preData(validPre,2),preData(validPre,3),10,[r,g,b],'Marker','*');
    
    [row,~]=find(sortedPost(i,1)==CPost(:,1));
    validPost=idxPost==row;
    scatter3(postData(validPost,1),postData(validPost,2),postData(validPost,3),10,[r,g,b],'Marker','o');
    view(3);
    
    
end

