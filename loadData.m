
dataFile='6.czi';

%keep track of which channel is the nuclei, presynaptic ribbon,
%postsynaptic density,etc
nuclei=1;
presynaptic=2;
postsynaptic=3;

%load in data, find mins and maxes, and get the meta data for the file
[voxel,dimensions,minMax,allData]=initialize(dataFile,1,2,3,4);

%set the thresholds for the data
 threshold=[.1,.11,.11,.05];
 
 %set the range forh te median filter
medRangeArray=[6,6;5,5;6,6;8,8];

%ignore this
plainData=allData;

%preallocate space for the filtered data based on metadata
allFiltered=zeros(dimensions(1),dimensions(2),dimensions(3),4,'logical');


%For the following fuinction to filter data
isNucleus=[true,false,false,false];
yRange=zeros(4,2);


startValue=50;
stopValue=6;
rStart=1;
rStop=1;

yRange(nuclei,:)=[1200,1500];
yRange(presynaptic)=[1200,1700];
yRange(postsynaptic)=[1200,1700];
startValues=zeros(4,2);
startValues(nuclei,:)=[startValue,stopValue];
startValues(presynaptic,:)=[rStart,rStop];
startValues(postsynaptic,:)=[rStart,rStop];




%filter data by channel
for b =1:4
    parfor i =1:size(allData,3)
        [allFiltered(:,:,i,b)]=initialThreshold(threshold(b),medRangeArray(b,:),allData(:,:,i,b),isNucleus(b),minMax(b,1),minMax(b,2),yRange(b,1),yRange(b,1),startValues(b,1),startValues(b,2));

    end
end
%set limits on which slices we want to look at

%set sensitivity for circle detection of nuclei
sensitivity=.972;
%set Y boundaries for the nuclei
range=[1200,1500];
%set estimated radius range of the nuclei
radius=[60,100];

%finds circles on each slice for hte nucleus channel using the filtered
%data
 [storeCenters,storeRadii]=viewPreliminaryData(allFiltered(:,:,:,nuclei),range,sensitivity,stopValue,startValue,radius,range(1),range(2));

 %clusters them together and outputs the final nucleus centers and radii
  [newCenters,mu,discardedN]=clusterNuclei(storeCenters,storeRadii,voxel);

%set Y range for ribbons
     range=[1200,1700];
    ribbonSlices=[presynaptic,postsynaptic];
    %set estimated radius of ribbons
    ribbonRadius=10;
    %search range for density based clustering
    epsilon=10;
    %min # of points to be considered ribbon
    minGroup=5;
    
    
    ribbon=struct([]);
    noFit=struct([]);
    
    
    %go through the presynaptic ribbon and postsynaptic density channels
    %for all slices using the filtered data
    for i = 1:2
        %Find all ribbon locations on each slice
        [ribbon(i).points]=ribbonStuff(allFiltered(:,:,:,ribbonSlices(i)),epsilon,minGroup,range,rStart,rStop);

        %Group the ribbon locations together to create a 3D ribbon location
        %array. This part does nto work very well yet.
        [ribbon(i).grouped,noFit]=ribbonAnalysis(ribbon(i).points,voxel);
        if i==1
            discardedRPre=noFit;
        else
            discardedRPost=noFit;
        end
    end

ribbon=removePreCloseRib(newCenters,ribbon,voxel);
%Ignore this part. It is just used to save time when I am experimenting
%with the GUI
    
    
[sendPre,sendPost]=ClusteredToSlice(ribbon,dimensions);
    
    
    
    
%     toGraph=struct([]);
%     for i = 1:size(ribbon.a,1)
%     end