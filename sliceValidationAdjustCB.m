%adjusts contrast and brightness

function [adjustedData]=sliceValidationAdjustCB(data,brightnessValue,contrastValue)


brightnessAdjusted=changeBrightness(brightnessValue,data);
[adjustedData]=changeContrast(contrastValue,brightnessAdjusted);



end