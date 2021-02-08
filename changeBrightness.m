function [brightnessAdjusted]=changeBrightness(brightness,data)
% 
% [brightnessAdjusted]=changeBrightness(brightness,data)
%   changeBrightness adds intensity to everything to make it easier to see
% 
%   brightnessAdjusted is the data after having the brightness adjusted
%
%   brightness is how much the data should get brighter
%   data is the data that is having hte intensity changed

dataType=class(data);
maxVal=intmax(dataType);

rescaledData=single(data)/single(maxVal);
%rescaledData=rescale(data,min(data,[],'all')/maxVal,max(data,[],'all')/maxVal);
brightnessAdjusted=min(rescaledData+brightness,1);
end