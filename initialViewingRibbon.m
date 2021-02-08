function [S1,S2,P1,P2,P3]=initialViewingRibbon(UIAxes1,UIAxes2,UIAxes3,data,medRange,threshold,epsilon,minGroup,range,radius,minimum,maximum)
% 
%   [S1,S2,P1,P2,P3]=initialViewingRibbon(UIAxes1,UIAxes2,UIAxes3,data,medRange,threshold,epsilon,minGroup,range,radius,minimum,maximum)
%
%   initialViewingRibbon allows the user to see the original data and the
%   detected ribbons to allow for settings to be optimized
% 
%   S1 is the scatter objects for the presynaptic data
%   S2 is the scatter objects for the postsynaptic data
%   P1 is the image object for the data
%   P2 is the image object for the filtered data
%   P3 is the image object for the filtered data
% 
%   UIAxes1-3 are the axes where the data is going to be graphed on
%   data is the actual data
%   medRange is a matrix with the median range used for reducing noise
%   threshold is the user input threshold used to make images more clear
%   for the computer
%   epsilon is the search range when clustering. Basically, how far apart
%   ribbons have to be in pixels to be considered separate
%   minGroup is how many pixels each ribbon needs to be to be considered a
%   ribbon instead of noise
%   range is the range the user is interested in
%   radius is a matrix with the estimated nucleus size 
%   yMin is the minimum y that the user is interested in
%   yMax is the maximum y that the user is interested in


isNucleus=false;
%threshold
allFiltered=initialThreshold(threshold,medRange,data,isNucleus,minimum,maximum,range(1),range(2),1,0);

startValue=1;
stopValue=0;

% range=[1000,2048];
% ribbonRadius=10;
% epsilon=10;
% minGroup=5;

%Print to gui
[ribbons]=ribbonStuff(allFiltered,epsilon,minGroup,range,startValue,stopValue);
if size(ribbons,1)>0
    [S1,S2,P1,P2,P3]=graphInitial(UIAxes1,UIAxes2,UIAxes3,data/max(data,[],'all'),allFiltered,ribbons(:,1:2),radius);
else
    [S1,S2,P1,P2,P3]=graphInitial(UIAxes1,UIAxes2,UIAxes3,data/max(data,[],'all'),allFiltered,[],radius);
end
graphLine(UIAxes1,range,size(data,2));

end