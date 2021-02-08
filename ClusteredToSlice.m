function [sendPre,sendPost]=ClusteredToSlice(ribbon,dimensions)
% [sendPre,sendPost]=ClusteredToSlice(ribbon,dimensions)
%
%   ClusteredToSlice takes the ribbon data having been grouped by the
%   clustering algorithm and turns it into data clustered by height
% 
%   sendPre is the presynaptic positions grouped by slice(struct)
%   sendPost is the postsynaptic positions grouped by slice(struct)
%   
%   ribbon is the ribbon data that was grouped by a clustering algorithm(struct)
%   dimensions is the dimensions of the data(matrix)
% 
% 


bySlice=struct([]);

for i = 1:2
    %Find all the ribbon locations as a large matrix
    allPoints=(vertcat(ribbon(i).grouped(:).grouped));
    
    allPoints2=[allPoints(:,1:2),round(allPoints(:,3))];
    %Go through each slice and find which ribbon locations fit onto each
    %slice
    for j = 1:dimensions(3)
        arr=allPoints((allPoints2(:,3)==j),:);
        bySlice(j).points=arr;
    end
    %Store as structure
    ribbon(i).bySlice=bySlice;
end
%%%
sendPre=ribbon.bySlice;
sendPost=ribbon(2).bySlice;