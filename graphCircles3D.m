function [S1]=graphCircles3D(UIAxes1,storeCenters,storeRadii,slice,color)
%     
% [S1]=graphCircles3D(UIAxes1,storeCenters,storeRadii,slice,color)
%
%   graphCircles3D takes shadow data for the nuclei, or ribbon locations on
%   a particular slice and graphs them in 3D
% 
%   S1 is a scatter object containing the circles for this slice and
%   channel
%   
%   UIAxes1 is the UIAxes that the scatter objects will be graphed on
%   storeCenters is a matrix containing location data for circle centers
%   storeRadii can either be a matrix containing radii or a scalar and
%   stores radius data for the organ
%   slice is the slice that this will be graphed on
%   color is the color that the scatter objects will be
% 
% 

    hold(UIAxes1,'on');

    S1(:,1)=scatter3(UIAxes1,storeCenters(:,1),storeCenters(:,2),slice*ones(size(storeCenters,1),1),storeRadii,color,'UserData',slice);

    hold(UIAxes1,'on');
    

end