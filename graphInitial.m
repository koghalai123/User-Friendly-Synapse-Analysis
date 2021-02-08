function [S1,S2,P1,P2,P3]=graphInitial(UIAxes1,UIAxes2,UIAxes3,data,allFiltered,storeCenters,storeRadii)
% 
% [S1,S2,P1,P2,P3]=graphInitial(UIAxes1,UIAxes2,UIAxes3,data,allFiltered,storeCenters,storeRadii)
%
%   graphInitial graphs the data on UIAxes to make it easy for the user to
%   find good input settings for organ detection and noise reduction
%
%   S1 is the scatter objects for the presynaptic data
%   S2 is the scatter objects for the postsynaptic data
%   P1 is the image object for the data
%   P2 is the image object for the filtered data
%   P3 is the image object for the filtered data
% 
%   UIAxes1-3 are the uiaxes that the detected organs and data is being
%   graphed on
%   data is the original data(matrix)
%   allFiltered is the filtered data(matrix)
%   storeCenters is a matrix storing the detected organs
%   storeRadii is a matrix storing the detected organs' radii
% 
% 
% 
% 

UIAxes1.cla;
UIAxes2.cla;
UIAxes3.cla;

% zoom(UIAxes1,'off');
% UIAxes1.XLimMode = 'auto';
% UIAxes1.YLimMode = 'auto';
% 
% zoom(UIAxes2,'off');
% UIAxes2.XLimMode = 'auto';
% UIAxes2.YLimMode = 'auto';
% 
% zoom(UIAxes3,'off');
% UIAxes3.XLimMode = 'auto';
% UIAxes3.YLimMode = 'auto';


P1=imshow(data/(max(data,[],'all')),'parent',UIAxes1);


P2=imshow(allFiltered,'parent',UIAxes2);
axis(UIAxes2,'equal');


P3=imshow(allFiltered,'parent',UIAxes3);
axis(UIAxes3,'equal');

%If the nuclei and radii need to be graphed, then return their objects. If
%not, return a non scatter object value.
if size(storeCenters,1)>0
    [S1,S2]=graphCircles(UIAxes1,UIAxes3,storeCenters,storeRadii);
else
    S1=1;
    S2=2;
end

end