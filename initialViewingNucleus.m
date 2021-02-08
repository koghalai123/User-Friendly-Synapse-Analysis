function [S1,S2,P1,P2,P3]=initialViewingNucleus(data,threshold,medRange,range,radius,sensitivity,UIAxes1,UIAxes2,UIAxes3,minimum,maximum,xMin,xMax)
% 
% [S1,S2,P1,P2,P3]=initialViewingNucleus(data,threshold,medRange,range,radius,sensitivity,UIAxes1,UIAxes2,UIAxes3,minimum,maximum,xMin,xMax)
%
%   intialViewingNucleus takes in user input data and uses it to show a
%   preliminary viewing of the data and detected organs
% 
%   S1 is the scatter objects for the presynaptic data
%   S2 is the scatter objects for the postsynaptic data
%   P1 is the image object for the data
%   P2 is the image object for the filtered data
%   P3 is the image object for the filtered data
% 
%   data is the actual data
%   threshold is the user input threshold
%   range is the range the user is interested in
%   radius is a matrix with the estimated nucleus size
%   sensitivity is the user input for how sensitive the circle detection
%   algorithm should be
%   UIAxes1-3 are the UIAxes that the stuff is graphed on
%   minimum is the globalMin for the nucleus channel
%   maximum is the globalMax for the nucleus channel
%   xMin is the minimum x that the user is interested in
%   xMax is the maximum x that the user is interested in
%
% 


 %threshold=[.1,.08,.08,.05];
%medRange=[8,8;3,3;3,3;4,4];
% nuclei=1;
% presynaptic=2;
% postsynaptic=3;
% extra=4;



%medRangeArray=[8,8;7,7;7,7;8,8];

isNucleus=true;

startValue=1;
stopValue=0;
%Threshold just one slice
% gradMag=imgradient(data);
% filled=imfill(gradMag,'holes');





[allFiltered]=initialThreshold(threshold,medRange,data,isNucleus,minimum,maximum,range(1),range(2),startValue,stopValue);



data2=data/max(data,[],'all');
% sensitivity=.972;
% range=[1200,1500];
% radius=[50,90];

%Find centers and radii
 [storeCenters,storeRadii]=viewPreliminaryData(allFiltered,range,sensitivity,stopValue,startValue,radius);

%graph to the GUI
[S1,S2,P1,P2,P3]=graphInitial(UIAxes1,UIAxes2,UIAxes3,data2,allFiltered,storeCenters,storeRadii);
graphLine(UIAxes1,range,size(data,2));
end
  



