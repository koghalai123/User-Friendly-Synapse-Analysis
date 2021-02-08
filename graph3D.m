function [A,B,C,S1,S2]=graph3D(UIAxes,ribbon,discardedRPre,discardedRPost,newCenters,mu,voxel,isScaled,ribbonRad)
% 
% [A,B,C,S1,S2]=graph3D(UIAxes,ribbon,discardedRPre,discardedRPost,newCenters,mu,voxel,isScaled,ribbonRad)
%
%   graph3D takes in various data about the ribbons and nuclei and graphs
%   them in 3D for humans to see
%
%   A is the surface objects of the presynaptic ribbons
%   B is the surface objects of the postsynaptic densities
%   C is the surface objects of the nuclei
%   S1 is the scatter objects of the unused detected presynaptic ribbons
%   S1 is the scatter objects of the unused detected postsynaptic densities
%
%   UIAxes is the uiaxes where this will be graphed
%   ribbon is the structure containing the ribbons grouped by a clustering
%   algorithm
%   discardedRPre is the structure containing the ribbon detections that
%   were clusterd out
%   discardedRPost is the structure containing the density detections that
%   were clusterd out
%   newCenters is a matrix containing the centers of the nuclei
%   mu is a matrix containing the radii of the nuclei
%   voxel is a matrix containing the voxel dimensions
%   isScaled allows the graphing to be done in either a to-scale 3D plot,
%   or a plot based on the pixels and slices.
%   ribbonRad is the user input of the ribbon sizes
% 

cla(UIAxes);

%This is so that I can switch between pixel view and a scaled view in
%microns
if isScaled
    forScale=voxel;
    axis(UIAxes,'equal');
elseif ~isScaled
    forScale=ones(1,3);
    axis(UIAxes,'normal');
end

hold(UIAxes,'on');
[x,y,z]=sphere;
C=gobjects();
%nuclei
for i = 1:size(newCenters,1)
    C(i,1)=surf(UIAxes,forScale(1)*(mu(i)*x+newCenters(i,1))/voxel(1),forScale(2)*(mu(i)*y+newCenters(i,2))/voxel(1),forScale(3)*(mu(i)*z+newCenters(i,3))/voxel(3),'FaceColor','c');
end
color=["b","g"];
A=gobjects();
B=gobjects();
%ribbona
for b = 1:2
    for j = 1:size(ribbon(b).grouped,2)
        
        M=ribbon(b).grouped(j).grouped;
        N=[mean(M(:,1)),mean(M(:,2)),M(1,3)+(M(end,3)-M(1,3))/2,(M(end,3)-M(1,3))/2];
        if b ==1
            A(j,1)=surf(UIAxes,forScale(1)*(ribbonRad*x+N(1)),forScale(2)*(ribbonRad*y+N(2)),forScale(3)*(N(4)*z+N(3)),'FaceColor',color(b),'EdgeColor','none');
        else
            
            B(j,1)=surf(UIAxes,forScale(1)*(ribbonRad*x+N(1)),forScale(2)*(ribbonRad*y+N(2)),forScale(3)*(N(4)*z+N(3)),'FaceColor',color(b),'EdgeColor','none');
        end
    end
end
%discarded ribbon points
if size(discardedRPre,1)>0
    S1=scatter3(UIAxes,forScale(1)*discardedRPre(:,1),forScale(2)*discardedRPre(:,2),forScale(3)*discardedRPre(:,3),10,'r');
end
if size(discardedRPost,1)>0
    S2=scatter3(UIAxes,forScale(1)*discardedRPost(:,1),forScale(2)*discardedRPost(:,2),forScale(3)*discardedRPost(:,3),10,'o');
end
hold(UIAxes,'off');

%legend and viewing angle
view(UIAxes,3);
legend(UIAxes,[A(1,1),B(1,1),C(1,1)],{'Presynaptic','Postsynaptic','Nuclei'});



% set(A(:,1),'UIAxesaceAlpha',0);
% 
% set(B(:,1),'UIAxesaceAlpha',0);

%axis(UIAxes,'equal');
end