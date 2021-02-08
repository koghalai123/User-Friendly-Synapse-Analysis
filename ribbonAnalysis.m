function [ribbonFinal,noFit]=ribbonAnalysis(ribbonPoints,voxel,groupSize)
% 
% [ribbonFinal,noFit]=ribbonAnalysis(ribbonPoints,voxel)
%
%   ribbonAnalysis takes the places on each slice where intense groups were
%   detected and clusters them together with a density based spatial
%   clustering algorithm
%
%   ribbonFinal is the structure containing the points, as well as the
%   points clusters by group
%   noFit is a structure containing the points that did not get clusters
%   into groups. This is assumed to be noise, but will be graphed later on
%   so that the user can be sure.
% 
%   ribbonPoints is a structure containing all the points on each slice
%   where intense points were detected
%   voxel is a matrix containign the voxel data
%
    noFit=[];
    ribbonFinal=struct([]);
    %just group the ribbons 
    idx=dbscan([ribbonPoints(:,1)*(voxel(1)),ribbonPoints(:,2)*(voxel(2)),ribbonPoints(:,3)*(voxel(3)/2)],.19,groupSize);
    
    D=ribbonPoints;
    %figure;
%     hold on;
    for i = 1:max(idx)+1
        if i <=max(idx)
            D(idx==i,4)=i;
        else
            D(idx==i,4)=i;
        end

    end
    for j = 0:max(idx)
        if j>=1
            points=D(j==D(:,4),:);
            %scatter3(points(:,1),points(:,2),points(:,3),5,colors(j,:));
            
            ribbonFinal(j).grouped=points;
        elseif j==0
            points=D(0==D(:,4),:);
            %scatter3(points(:,1),points(:,2),points(:,3),5,[0,0,0]);
            if size(points,1)>0
                noFit=points(:,1:3);
            end
        end
    end
end