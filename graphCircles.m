function [S1,S2]=graphCircles(UIAxes1,UIAxes3,storeCenters,storeRadii,color)
% 
% [S1,S2]=graphCircles(UIAxes1,UIAxes3,storeCenters,storeRadii,color)
%
%   graphCircles is a function that graphs the detected circles on UIAxes1
%   and 3
% 
%   S1 is the scatter objects on UIAxes1
%   S2 is the scatter objects on UIAxes3
%   
%   UIAxes1 is the UIAxes that the circles should be graphed on
%   UIAxes3 is the UIAxes that the circles should be graphed on
%   storeCenters is the matrix of detected centers
%   storeRadii is the matrix of radii for these nuclei
%   color is the color that the circles will be graphed in. This lets the
%   user see a difference between detected circles and circles that were
%   actually used in the analysis
% 
% 

if nargin==4
    hold(UIAxes1,'on');
    hold(UIAxes3,'on');

    S1=scatter(UIAxes1,storeCenters(:,1),storeCenters(:,2),storeRadii,'g');
    S2=scatter(UIAxes3,storeCenters(:,1),storeCenters(:,2),storeRadii,'g');

    hold(UIAxes1,'on');
    hold(UIAxes3,'on');
else
    
    hold(UIAxes1,'on');
    hold(UIAxes3,'on');

    S1(:,1)=scatter(UIAxes1,storeCenters(:,1),storeCenters(:,2),storeRadii,color);
    S2(:,1)=scatter(UIAxes3,storeCenters(:,1),storeCenters(:,2),storeRadii,color);

    hold(UIAxes1,'on');
    hold(UIAxes3,'on');
end
end


