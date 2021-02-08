%addpath('F:\Ribbon Analysis Data Sets\Blinded data');


for fileName=83:87
    dataFile=strcat(num2str(fileName),'.czi');
    addPathString=strcat('F:\RibbonAnalysisDataSets\BlindedData\',dataFile);
    movefile(addPathString,'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');
    
    settingsFile=strcat(num2str(fileName),'SettingsMat.mat');
    addPathSettingsString=strcat('F:\RibbonAnalysisDataSets\settings\',settingsFile);
    movefile(addPathSettingsString,'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');
    load(settingsFile);
    %keep track of which channel is the nuclei, presynaptic ribbon,
    %postsynaptic density,etc
    nuclei=1;
    presynaptic=matValues(1);
    postsynaptic=matValues(2);
    
    zScaleFactor=10;
    
    startValues=zeros(4,2);
    startValues(nuclei,:)=[(matValues(3)-1)*zScaleFactor+1,(matValues(4)-1)*zScaleFactor+1];
    startValues(presynaptic,:)=[(matValues(8)-1)*zScaleFactor+1,(matValues(9)-1)*zScaleFactor+1];
    startValues(postsynaptic,:)=[(matValues(8)-1)*zScaleFactor+1,(matValues(9)-1)*zScaleFactor+1];
    
    threshNuc=matValues(7);
    threshPre=matValues(12);
    threshPost=matValues(13);

    
    

    %load in data, find mins and maxes, and get the meta data for the file
     [voxel,dimensions,minMax,allData]=initialize(dataFile,1,2,3,4);
    threshold=ones(1,4);

    XYScaleFactor=dimensions(1:2)./[500,500];
    yRange=zeros(4,2);
    yRange(nuclei,:)=round([matValues(5)*XYScaleFactor(1),matValues(6)*XYScaleFactor(2)]);
    yRange(presynaptic,:)=round([matValues(10)*XYScaleFactor(1),matValues(11)*XYScaleFactor(2)]);
    yRange(postsynaptic,:)=round([matValues(10)*XYScaleFactor(1),matValues(11)*XYScaleFactor(2)]);

%     threshPre=prctile(allData(:,:,:,presynaptic),98.5,'all')/max(allData(:,:,:,presynaptic),[],'all');
%     threshPost=prctile(allData(:,:,:,postsynaptic),99.2,'all')/max(allData(:,:,:,postsynaptic),[],'all');
%     threshNuc=prctile(allData(:,:,:,1),84,'all')/max(allData(:,:,:,1),[],'all');
% 
    threshold(1)=threshNuc;
    threshold(presynaptic)=threshPre;
    threshold(postsynaptic)=threshPost;
%     threshold(nuclei)=.08;
%     threshold(presynaptic)=.07;
%     threshold(postsynaptic)=.07;

    %set the thresholds for the data

     %set the range forh te median filter
    medRangeArray=[6,6;5,5;5,5;1,1];

    %ignore this
    plainData=allData;

    %preallocate space for the filtered data based on metadata
    allFiltered=zeros(dimensions(1),dimensions(2),dimensions(3),4,'logical');


    %For the following fuinction to filter data
    isNucleus=[true,false,false,false];



%     startValue=1;
%     stopValue=1;
%     rStart=1;
%     rStop=1;
% 
%     yRange(nuclei,:)=[1,size(allData,2)];
%     yRange(presynaptic,:)=[1,size(allData,2)];
%     yRange(postsynaptic,:)=[1,size(allData,2)];
%     startValues=zeros(4,2);
%     startValues(nuclei,:)=[startValue,stopValue];
%     startValues(presynaptic,:)=[rStart,rStop];
%     startValues(postsynaptic,:)=[rStart,rStop];




    %filter data by channel
    for b =1:3
            [allFiltered(:,:,:,b)]=initialThreshold(threshold(b),medRangeArray(b,:),allData(:,:,:,b),isNucleus(b),minMax(b,1),minMax(b,2),yRange(b,1),yRange(b,2),startValues(b,1),startValues(b,2));

    end
    %set limits on which slices we want to look at

    %set sensitivity for circle detection of nuclei
    sensitivity=.972;
    %set Y boundaries for the nuclei
%     range=[1,size(allData,2)];
    %set estimated radius range of the nuclei
    radius=[60,100];
    range=yRange(1,:);
    %slice for hte nucleus channel using the filtered
    %data
    startValue=startValues(1,1);
    stopValue=startValues(1,2);

     [storeCenters,storeRadii]=viewPreliminaryData(allFiltered(:,:,:,nuclei),range,sensitivity,stopValue,startValue,radius);

     %clusters them together and outputs the final nucleus centers and radii
      [newCenters,mu,discardedN]=clusterNuclei(storeCenters,storeRadii,voxel);


      nucClusters=struct([]);
      idx=dbscan([newCenters(:,2),newCenters(:,3)],3,4);
      for i=1:max(idx)
          temp=[];
          temp=newCenters(idx==i,:);
          avg=mean(temp,1);
          nucClusters(i).cluster=temp;
          nucClusters(i).avg=avg;
      end
      


      epsilon=4;
      minGroup=4;
      rangeR=[yRange(2,1),yRange(2,2)];
      RFirst=startValues(presynaptic,1);
      RLast=startValues(presynaptic,2);
      ribbonSlices=[presynaptic,postsynaptic];
    %     epsilon=10;
    %     minGroup=5;
        ribbon=struct([]);
        noFit=struct([]);


        %go through the presynaptic ribbon and postsynaptic density channels
        %for all slices using the filtered data
        groupSize=[3,3];
        for i = 1:2
            %Find all ribbon locations on each slice
            [ribbon(i).points]=ribbonStuff(allFiltered(:,:,:,ribbonSlices(i)),epsilon,minGroup,rangeR,RFirst,RLast);

            %Group the ribbon locations together to create a 3D ribbon location
            %array. This part does nto work very well yet.

        end
        for j = 1:2
            [ribbon(j).grouped,noFit]=ribbonAnalysis(ribbon(j).points,voxel,groupSize(j));
            if j==1
                discardedRPre=noFit;
            else
                discardedRPost=noFit;
            end
        end

    ribbon=removePreCloseRib(newCenters,ribbon,voxel);
    %Ignore this part. It is just used to save time when I am experimenting
    %with the GUIfunction [locations]=findSynapseLocationsFromStruct(synapseStruct)
%     for b=1:2
%         [ribbon(b).locations]=findSynapseLocationsFromStruct(ribbon(b).grouped);
%     end
%     [rangeLims]=findRibbonRange(ribbon(2).locations,95);
%     for b =1:2
%         inYRange=ribbon(b).locations(:,2)>rangeLims(1,1)&ribbon(b).locations(:,2)<rangeLims(1,2);
%         inZRange=ribbon(b).locations(:,3)>rangeLims(2,1)&ribbon(b).locations(:,3)<rangeLims(2,2);
%         inRange=inYRange&inZRange;
%         inRangeInd=(find(inRange==1));
%         inRangeStruct=struct();
%         for i =1:size(inRangeInd,1)
%             inRangeStruct(i).grouped=ribbon(b).grouped(inRangeInd(i)).grouped;
%         end
%         ribbon(b).inRange=inRangeStruct();
%     end
% 
%     for b=1:2
%         [ribbon(b).inRangeLocations]=findSynapseLocationsFromStruct(ribbon(b).inRange);
%     end

    [sendPre,sendPost]=ClusteredToSlice(ribbon,dimensions);
    saveData(1,num2str(fileName),[newCenters,mu],ribbon,voxel,1,1,1,1);

    rmPathString=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',dataFile);
    movefile(rmPathString,'F:\RibbonAnalysisDataSets\BlindedData');
    
    movefile(strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\', settingsFile),'F:\RibbonAnalysisDataSets\settings');

    clear all;
 end
