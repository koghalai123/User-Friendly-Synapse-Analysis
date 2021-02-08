%allwos a new threshold to be chosen

function []=sliceValidationNewThresh(obj,~,app,f,displayCounts,thresholdInput,toggleCirclesButton,fileNum,channel,filtered,dimensions,voxel,epsilon,rangeR,minGroup,groupSize)
obj.BackgroundColor='r';
drawnow;

nucleusData=[app.newCenters,app.mu];
threshMat=str2num(thresholdInput.String);

limitDataName=strcat(num2str(fileNum),'YZLims.mat');
movefile(strcat('F:\RibbonAnalysisDataSets\LimitData\',limitDataName),'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');
load(limitDataName);
movefile(strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',limitDataName),'F:\RibbonAnalysisDataSets\LimitData');

[points,grouped]=findRib(filtered,nucleusData,threshMat,dimensions,voxel,1,1,epsilon,rangeR,minGroup,groupSize);


coords=zeros(size(grouped,2),3);
for i = 1:size(grouped,2)
    coords(i,:)=mean(grouped(i).grouped(:,1:3),1);
end

outY=(coords(:,2)<lims.ribLims(1,1) | coords(:,2)>lims.ribLims(1,2));
outZ=(coords(:,3)<lims.ribLims(2,1) | coords(:,3)>lims.ribLims(2,2));
outside=outY | outZ;
inside=find(outside==0);
counter=1;
newRibbons=struct();
if channel==2
    newRibbons(2).grouped=app.ribbon(2).grouped;
    for j=1:size(inside,1)
        newRibbons(1).grouped(counter).grouped=grouped(inside(j)).grouped;
        counter=counter+1;
    end
    if size(newRibbons(1).grouped,2)==0
        newRibbons(1).grouped(1).grouped=[0,0,0,1];
    end
    app.ribbon(1).grouped=newRibbons(1).grouped;
elseif channel==3
    newRibbons(1).grouped=app.ribbon(1).grouped;
    for j=1:size(inside,1)
        newRibbons(2).grouped(counter).grouped=grouped(inside(j)).grouped;
        counter=counter+1;
    end
    if size(newRibbons(2).grouped,2)==0
        newRibbons(2).grouped(1).grouped=[0,0,0,1];
    end
    app.ribbon(2).grouped=newRibbons(2).grouped;
end


sliceValidationMatchRibGroupToIndex(app);
[app.presynapticPositions,app.postsynapticPositions]=ClusteredToSlice(newRibbons,app.dimensions);
sliceValidationRMEmpty(app);
delete(findobj(f.CurrentAxes.Children,'type','scatter'))

slice=str2double(f.Name(7:end));
sliceValidationGraphRibbons(f,app,slice,toggleCirclesButton);
displayString=strcat('Presynaptic: ',num2str(size(app.ribbon(1).grouped,2)),' Postsynaptic: ',num2str(size(app.ribbon(2).grouped,2)));
displayCounts.String=displayString;
obj.BackgroundColor=[.94,.94,.94];
drawnow;
end