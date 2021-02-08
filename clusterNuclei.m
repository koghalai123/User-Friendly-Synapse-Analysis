function [newCenters,mu,discardedN]=clusterNuclei(storeCenters,storeRadii,voxel)
% 
% [newCenters,mu,discardedN]=clusterNuclei(storeCenters,storeRadii,voxel)
%
%   newCenters is the center of the nuclei found by a spherefit algorithm
%   mu is the radii of the nuclei found by a spherefit algorithm
%   discardedN are the circles found by the program that were not used in
%   the fit due to being clusters out
% 
%   storeCenters is a structure containing the circles detected on each
%   slice
%   storeRadii is a structure containing the radii of the circles detected
%   on each slice
%   voxel is a matrix with the voxel data
% 
% 
% 

%     [b,idx2,outliers]=deleteoutliers([storeCenters(:,1),storeCenters(:,2)*1.5],.15);

%Density based clustering
idx=dbscan([storeCenters(:,1),storeCenters(:,2),storeCenters(:,3)],25,6);
% gscatter(storeCenters(:,1),storeCenters(:,2),idx);
%gscatter(storeCenters(:,1),storeCenters(:,2),idx);
grouped=struct([]);

discardedN(:,1:3)=storeCenters(idx(:,1)==-1,:);
discardedN(:,4)=storeRadii(idx(:,1)==-1,:);


%Remove the data points which did not fit into clusters
storeCenters=storeCenters(idx(:,1)~=-1,:);
storeRadii=storeRadii(idx(:,1)~=-1,:);
idx=idx(idx(:,1)~=-1,:);

%separate the data points by cluster
for j = 1:max(idx)
    A=find(idx==j);
    grouped(j).points=storeCenters(A,:);
    grouped(j).radii=storeRadii(A,:);
end

%setup to speed up upcoming for loop
theta=linspace(0,2*pi,5)';
newCenters=[];
mu=[];
cosTheta=cos(theta);
sinTheta=sin(theta);

%Use radii and centers to create points and use those for a spherefit
%algorithm
for i = 1:size(grouped,2)
    points=[];
    for j = 1:size(grouped(i).points,1)
        points((j-1)*5+1:j*5,1:3)=[voxel(1)*(grouped(i).points(j,1)+grouped(i).radii(j,1)*cosTheta),(voxel(2))*(grouped(i).points(j,2)+grouped(i).radii(j,1)*sinTheta),ones(5,1).*grouped(i).points(j,3)*(voxel(3))];
    end
    %return nuclei centers and radii
    [center,radius]=sphereFit(points);
    newCenters(i,1:3)=center;
    mu(i,1)=radius;
end
end

    