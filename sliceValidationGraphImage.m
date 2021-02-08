%graphs the image

function [fObj]=sliceValidationGraphImage(fObj,data,slice,brightnessSlider,contrastSlider)
cla reset;

toggleBothChannelsButton=findobj(fObj.Children(1).Children,'UserData','toggleBothChannelsButton');
channelData=toggleBothChannelsButton.ChannelData;

adjustedData=sliceValidationAdjustCB(data(:,:,slice,:),brightnessSlider.Value,contrastSlider.Value);
fObj.Name=strcat('Slice: ',num2str(slice));


if toggleBothChannelsButton.Value==1
    rgb=cat(3,adjustedData(:,:,:,channelData(1)),adjustedData(:,:,:,channelData(2)),zeros(size(adjustedData,1),size(adjustedData,2),size(adjustedData,3),1));
    imshow(rgb,'DisplayRange',[0,1],'Parent',fObj.CurrentAxes);
else
    imshow(adjustedData(:,:,:,channelData(3)),'DisplayRange',[0,1],'Parent',fObj.CurrentAxes);
end
end