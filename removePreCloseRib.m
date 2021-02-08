function [toReturn]=removePreCloseRib(nucleusData,ribbonData,voxel)
% 
% [toReturn]=removePreCloseRib(nucleusData,ribbonData,voxel)
%
%   removePreCloseRib removes ribbons that are within a certain micron
%   distance of the nuclei. This is used because the antibody that we
%   originally used to mark the presynaptic ribbons also marked the nuclei,
%   so we ended up getting ribbons in the nuclei when there weren't any.
%   This function removes them.
%
%   toReturn are the ribbons that are outside the nucleus
% 
%   nucleusData is a matrix containing the nucleus position and radius
%   ribbonData is a structure containing all of the ribbons grouped by a
%   clustering algorithm
%   voxel is a matrix of voxel data
% 
% 
% 

newRibbonData=struct([]);
for b = 1:2    
    newRibbonData=struct([]);
    %Find average ribbon XYZ
    avgPre=cell2mat(transpose(arrayfun(@(s) mean(s(:).grouped,1), ribbonData(b).grouped, 'UniformOutput', false)));
    %Turn it to distance
    scaledPre=[avgPre(:,1)*voxel(1),avgPre(:,2)*voxel(2),avgPre(:,3)*voxel(3)];
    dist=zeros(size(scaledPre,1),size(nucleusData,1));
    %Find distances to nuclei
    for i = 1:size(nucleusData,1)
        dist(:,i)=(((nucleusData(i,1)-scaledPre(:,1)).^2)+((nucleusData(i,2)-scaledPre(:,2)).^2)+((nucleusData(i,3)-scaledPre(:,3)).^2)).^(1/2);
    end
    %Find the ones that are too close
    [row,~]=find(dist<3.8);
    toDelete=[];
    toDelete=unique(row);
    allGroups=[1:size(scaledPre,1)];
    counter=1;
    %Dont include the ones that are too close in the return
    for group=1:size(scaledPre,1)
        if ~any(toDelete==group)
            newRibbonData(counter).grouped=ribbonData(b).grouped(allGroups(group)).grouped;
            counter=counter+1;
        end
    end
    ribbonData(b).grouped=newRibbonData;
end    
    toReturn=ribbonData;
end