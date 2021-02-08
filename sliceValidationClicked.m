%callbacks for if the user clicks on the window

function sliceValidationClicked(obj,event,app,f,dimensions,toggleCirclesButton,displayCounts)

clickedLoc=obj.CurrentAxes.CurrentPoint;
slice=str2double(obj.Name(7:end));
rib=app.ribbon(str2double(app.TiffSliceValidationDropDown.Value)-1).grouped;

if strcmp(obj.SelectionType,'normal')
    [avgSize]=round(mean(arrayfun(@(s) size(s.grouped,1),app.ribbon(str2double(app.TiffSliceValidationDropDown.Value)-1).grouped)));
    lowestSlice=max(round(slice-avgSize/2),1);
    highestSlice=min(round(slice+avgSize/2),dimensions(3));
    sliceMat=[lowestSlice:highestSlice]';
    rib(size(rib,2)+1).grouped=[repmat(clickedLoc(1,1:2),size(sliceMat,1),1),sliceMat,ones(size(sliceMat,1),1)*size(rib,2)+1];
    app.ribbon(str2double(app.TiffSliceValidationDropDown.Value)-1).grouped=rib;
    
elseif strcmp(obj.SelectionType,'alt')
    
    temp3=app.postsynapticPositions;
    
    sliceValidationMatchRibGroupToIndex(app);
    [app.presynapticPositions,app.postsynapticPositions]=ClusteredToSlice(app.ribbon,dimensions);
    if str2double(app.TiffSliceValidationDropDown.Value)-1==1
        minDistInd=dsearchn(single(app.presynapticPositions(slice).points(:,1:2)),single(clickedLoc(1,1:2)));
        ribNum=app.presynapticPositions(slice).points(minDistInd,4);
    elseif str2double(app.TiffSliceValidationDropDown.Value)-1==2
        minDistInd=dsearchn(single(app.postsynapticPositions(slice).points(:,1:2)),single(clickedLoc(1,1:2)));
        ribNum=app.postsynapticPositions(slice).points(minDistInd,4);
    end
    temp1=app.ribbon(str2double(app.TiffSliceValidationDropDown.Value)-1).grouped(ribNum).grouped;
    
    temp2=app.ribbon;
    
    
    
    app.ribbon(str2double(app.TiffSliceValidationDropDown.Value)-1).grouped(ribNum).grouped=[];
    sliceValidationRMEmpty(app)
end
[app.presynapticPositions,app.postsynapticPositions]=ClusteredToSlice(app.ribbon,dimensions);
delete(findobj(f.CurrentAxes.Children,'type','scatter'))
sliceValidationGraphRibbons(f,app,slice,toggleCirclesButton);
displayString=strcat('Presynaptic: ',num2str(size(app.ribbon(1).grouped,2)),' Postsynaptic: ',num2str(size(app.ribbon(2).grouped,2)));
displayCounts.String=displayString;
drawnow;
end