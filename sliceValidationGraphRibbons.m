%graphs the ribbons

function sliceValidationGraphRibbons(f,app,slice,toggleCirclesButton)
[~,Centers,~,~] = findStats(app,str2double(app.TiffSliceValidationDropDown.Value),slice);
if size(Centers,1)>0
    hold(f.Children(2).Children  ,'on');
    circles=scatter(f.Children(2).Children,Centers(:,1),Centers(:,2),30,'b');
    hold(f.Children(2).Children  ,'off');
end
if toggleCirclesButton.Value==1
    circles.Visible=0;
end

end