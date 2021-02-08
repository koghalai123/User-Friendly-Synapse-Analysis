%I have no idea what the difference between this and the other one is

function sliceValidationCBChanged(~,~,brightnessSlider,contrastSlider,f,app,data,brightnessLabel,contrastLabel,toggleCirclesButton)

slice=str2double(f.Name(7:end));

sliceValidationGraphImage(f,data,slice,brightnessSlider,contrastSlider);
sliceValidationGraphRibbons(f,app,slice,toggleCirclesButton);

brightnessLabel.String=strcat('Brightness: ',num2str(brightnessSlider.Value));
contrastLabel.String=strcat('Contrast: ',num2str(contrastSlider.Value));


end