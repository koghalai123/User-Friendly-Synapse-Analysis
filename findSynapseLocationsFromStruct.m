function [locations]=findSynapseLocationsFromStruct(synapseStruct)

% function [locations]=findSynapseLocationsFromStruct(synapseStruct)
% 
% this function takes in a structure with locations on each slice and finds
% the means to find the center of the organ
%
% synapsStruct is a structure 
% locations is a matrix with the centers of each organ


locations=zeros(size(synapseStruct,2),3);
for i = 1:size(synapseStruct,2)
    x=mean(synapseStruct(i).grouped(:,1));
    y=mean(synapseStruct(i).grouped(:,2));
    z=mean(synapseStruct(i).grouped(:,3));
    locations(i,:)=[x,y,z];
end


end