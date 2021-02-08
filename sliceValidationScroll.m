%allows scrolling through the window

function sliceValidationScroll(obj,event,app,f,dimensions,data,brightnessSlider,contrastSlider,toggleCirclesButton)
previousSlice=str2double(obj.Name(7:end));
currentSlice=previousSlice+event.VerticalScrollCount;
currentSliceWLims=max(min(currentSlice,dimensions(3)),1);
[fObj]=sliceValidationGraphImage(f,data,currentSliceWLims,brightnessSlider,contrastSlider);
sliceValidationGraphRibbons(f,app,currentSliceWLims,toggleCirclesButton)
end