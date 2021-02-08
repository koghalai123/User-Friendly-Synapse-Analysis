%finds ribbons and densities

function [points,grouped]=findRib(filtered,nucleusData,threshMat,dimensions,voxel,RFirst,RLast,epsilon,rangeR,minGroup,groupSize)
finalData=zeros(dimensions(1),dimensions(2),dimensions(3),1,'logical');

finalData(:,:,:)=rescale(filtered(:,:,:))>threshMat;



ribbon=struct([]);

[points]=ribbonStuff(finalData(:,:,:),epsilon,minGroup,rangeR,RFirst,RLast);

%Group the ribbon locations together to create a 3D ribbon location
%array. This part does nto work very well yet.

[grouped,noFit]=ribbonAnalysis(points,voxel,groupSize);

% f3=figure;
% hold on;
% for i= 1:size(grouped,2)
%     r=rand;
%     g=rand;
%     b=rand;
%     scatter3(grouped(i).grouped(:,1),grouped(i).grouped(:,2),grouped(i).grouped(:,3),55,[r,g,b],'linewidth',2);
% end
% scatter3(noFit(:,1),noFit(:,2),noFit(:,3),200,[1,0,0],'x');
% view(3);
% xlim([1424,1748]);
% ylim([1424,1748]);

end