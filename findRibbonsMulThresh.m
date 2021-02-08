%Not being used

for isViable=1
    dataSettings=readtable('DataSettings2.xlsx');
    viable=table2array(dataSettings(:,1));
%       try
        
        fileName=viable(isViable);
        dataFile=strcat(num2str(fileName),'.czi');
        [voxel,dimensions,minMax,allData]=saveAllDSTiff(fileName);
        

        %keep track of which channel is the nuclei, presynaptic ribbon,
        %postsynaptic density,etc
        nuclei=1;
        presynaptic=2;
        postsynaptic=3;

        

        %load in data, find mins and maxes, and get the meta data for the file
        threshold=ones(1,4);




        %preallocate space for the filtered data based on metadata
        allFiltered=zeros(dimensions(1),dimensions(2),dimensions(3),4,'logical');
        allFiltered2=zeros(dimensions(1),dimensions(2),dimensions(3),4,'double');



%         [newCenters,mu]=retrieveNuclei(fileName);

    %   
%          discardedN=[];
%          if size(newCenters,1)==0
%              newCenters=[1,1,1];
%              mu=1;
%              
%          end 

        orgMat=[presynaptic,postsynaptic];

        settings=[7,7,1,table2array(dataSettings(isViable,8))+.03;7,7,1,table2array(dataSettings(isViable,9))];

        %filter data by channel
        for b =1:2
    %             [allFiltered(:,:,:,b)]=initialThreshold(threshold(b),medRangeArray(b,:),allData(:,:,:,b),isNucleus(b),minMax(b,1),minMax(b,2),yRange(b,1),yRange(b,2),startValues(b,1),startValues(b,2));
            rmBig=postFiltering(dimensions,allData,orgMat(b),settings(b,:));
            allFiltered2(:,:,:,b+1)=(rmBig);
            allFiltered(:,:,:,b+1)=rmBig>settings(b,4);
    
        end
        folderName=strcat(num2str(fileName),'FilteredData');
        storageLocation='F:\RibbonAnalysisDataSets\FilteredData';
        saveAsTiff(allFiltered2,folderName,fileName,storageLocation,voxel,dimensions,minMax)
        
%         
% 
%         RFirst=1;
%         RLast=1;
%         epsilon=4;
%         rangeR=[1,dimensions(2)];
%         minGroup=6;
%         ribbon=struct([]);
%         %go through the presynaptic ribbon and postsynaptic density channels
%             %for all slices using the filtered data
%             groupSize=[4,3];
%             for i = 1:2
%                 %Find all ribbon locations on each slice
%                 [ribbon(i).points]=ribbonStuff(allFiltered(:,:,:,i+1),epsilon,minGroup,rangeR,RFirst,RLast);
% 
%                 %Group the ribbon locations together to create a 3D ribbon location
%                 %array. This part does nto work very well yet.
% 
%             end
%             for j = 1:2
%                 [ribbon(j).grouped,noFit]=ribbonAnalysis(ribbon(j).points,voxel,groupSize(j));
%                 if j==1
%                     discardedRPre=noFit;
%                 else
%                     discardedRPost=noFit;
%                 end
%             end
% 



%        saveData(1,strcat(num2str(fileName),'FinalNoCheck'),[newCenters,mu],ribbon,voxel,1,1,1,1,presynaptic,postsynaptic,dimensions);

%         rmPathString=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',dataFile);
%         movefile(rmPathString,'F:\RibbonAnalysisDataSets\BlindedData');

    %     movefile(strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\', settingsFile),'F:\RibbonAnalysisDataSets\settings');

         clear all;
%       catch
%          try
%             rmPathString=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',dataFile);
%             movefile(rmPathString,'F:\RibbonAnalysisDataSets\BlindedData');
%         catch 
%         end
%          disp('error');
%      end
 end