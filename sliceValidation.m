%sets up a window to validate the ribbons and densities

function [f]=sliceValidation(app,allData,channel)

rawData=allData(:,:,:,:);

f=figure('units','normalized','outerposition',[0 0 1 1]);

graphingPanel=uipanel(f,'Position',[.33,0,.66,1]);
inputsPanel=uipanel(f,'Position',[0,0,.33,1]);
a=axes(graphingPanel);

brightnessSlider=uicontrol(inputsPanel,'Value',.3,'Style','slider','Units','Normalized','Position',[.3,.9,.7,.1],'UserData','brightnessSlider');
contrastSlider=uicontrol(inputsPanel,'Value',.3,'Style','slider','Max',.5,'Units','Normalized','Position',[.3,.8,.7,.1],'UserData','contrastSlider');

brightnessLabel=annotation(inputsPanel,'textbox',[0,.9,.3,.1],'String','Brightness: 0','UserData','brightnessLabel');
contrastLabel=annotation(inputsPanel,'textbox',[0,.8,.3,.1],'String','Contrast: 0','UserData','contrastLabel');
toggleCirclesButton=uicontrol(inputsPanel,'Style','togglebutton','String','Hide Circles','Units','Normalized','Position',[0,.7,.3,.1],'UserData','toggleCirclesButton');
showBothChannelsButton=uicontrol(inputsPanel,'Style','togglebutton','String','Toggle Both Channels','Units','Normalized','Position',[.3,.7,.5,.1],'UserData','toggleBothChannelsButton');

set(brightnessSlider,'Callback',{@sliceValidationCBChanged,brightnessSlider,contrastSlider,f,app,rawData,brightnessLabel,contrastLabel,toggleCirclesButton});
set(contrastSlider,'Callback',{@sliceValidationCBChanged,brightnessSlider,contrastSlider,f,app,rawData,brightnessLabel,contrastLabel,toggleCirclesButton});
set(toggleCirclesButton,'Callback',{@sliceValidationToggleCircles,f});
%this is to update the picture after it is toggled
set(showBothChannelsButton,'Callback',{@sliceValidationCBChanged,brightnessSlider,contrastSlider,f,app,rawData,brightnessLabel,contrastLabel,toggleCirclesButton});

addprop(showBothChannelsButton,'ChannelData');

showBothChannelsButton.ChannelData=[2,3,channel];

sliceValidationMatchRibGroupToIndex(app);

dimensions=size(rawData);

[f]=sliceValidationGraphImage(f,rawData,1,brightnessSlider,contrastSlider);
sliceValidationGraphRibbons(f,app,1,toggleCirclesButton);


f.NumberTitle='off';

set(f,'WindowScrollWheelFcn',{@sliceValidationScroll,app,f,dimensions,rawData,brightnessSlider,contrastSlider,toggleCirclesButton});
set(f,'WindowButtonDownFcn',{@sliceValidationClicked,app,f,dimensions,toggleCirclesButton});


end