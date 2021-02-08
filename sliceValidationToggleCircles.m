%allows circles to be t oggled off and on
function sliceValidationToggleCircles(~,~,f)
toggleButtonObj=findobj(f.Children(1).Children,'UserData','toggleCirclesButton');
if toggleButtonObj.Value==1
    
    if ~isempty(findobj(f.Children(2).Children,'type','scatter'))
        scatterObj=findobj(f.Children(2).Children,'type','scatter');
        scatterObj.Visible=0;
    end
    toggleButtonObj.String='Show Circles';
    
elseif toggleButtonObj.Value==0
    if ~isempty(findobj(f.Children(2).Children,'type','scatter'))
        scatterObj=findobj(f.Children(2).Children,'type','scatter');
        scatterObj.Visible=1;
        
    end
    
    toggleButtonObj.String='Hide Circles';
end


end