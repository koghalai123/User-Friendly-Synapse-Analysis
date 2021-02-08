function addRibbon(obj,event,g,app)

% addRibbon(obj,event,g,app)
%
%     addRibbon is a callback function that takes in a 3D stack of
%     hgtransforms, as well as scatter objects for each Z height. It will
%     add a ribbon to app.ribbons.grouped and replot the scatter objects.
%   
%   obj is the figure window
%   event is the ButtonDownFcn callback
%   g is the stack of hgtransforms
%   app is the GUI


ax=obj.CurrentAxes;

% Determines if the user clicked on the UIAxes
if strcmpi(obj.SelectionType, 'open') % if it is a double-click event
    if str2double(app.CheckThatDataDropDown.Value)==1 %check which channel is being displayed
    elseif str2double(app.CheckThatDataDropDown.Value)==2 || str2double(app.CheckThatDataDropDown.Value)==3
        %find the number of visible slices
        on=size(findobj(g,'Visible',1),1);
        %Find the number of ribbons in the set that is being looked at
        en=size(app.ribbon(str2double(app.CheckThatDataDropDown.Value)-1).grouped,2);
        %Find the sizes of each of the ribbons and store as array
        [ans1]=(arrayfun(@(s) size(s.grouped,1),app.ribbon(str2double(app.CheckThatDataDropDown.Value)-1).grouped));
        %Use the sizes of the ribbons in the array to determins a representative ribbon size
        ans3=round(sum(ans1)/(2*en));
        low=(on/2-ans3-2); %Determine how many slices above and below the targeted slice should also be included in the ribbon
        high=(on/2+ans3+3); 
        if low <1 %Make sure that the slices above/below the targeted slice are viable. If you are too close to the end of the slice stack, the minimums are automatically adjusted
            low=1;
        elseif high>size(g,2)
            high=size(g,2);
        end
        
        lowSearch=(on/2-2*ans3-2); %Determine how many slices above and below the targeted slice should also be included in the ribbonsearch
        highSearch=(on/2+2*ans3+2); 
        if lowSearch <1 %Make sure that the slices above/below the targeted slice are viable. If you are too close to the end of the slice stack, the minimums are automatically adjusted
            lowSearch=1;
        elseif highSearch>size(g,2)
            highSearch=size(g,2);
        end
        
        
        cursorLoc=[ax.CurrentPoint(1,1),ax.CurrentPoint(1,2),on/2];
        searchRange=.125./app.voxel(1:2);
        searchMat=round([[cursorLoc(1:2)-searchRange;cursorLoc(1:2)+searchRange],[lowSearch;highSearch]]);        
        dataMat=app.plainData(searchMat(1,1):searchMat(2,1),searchMat(1,2):searchMat(2,2),searchMat(1,3):searchMat(2,3));
        maxIntensity=max(max(max(dataMat,[],1),[],2),[],3);
        [r,c,v] = ind2sub(size(dataMat),find(dataMat == maxIntensity));
        coords=searchMat(1,:)+[r,c,v];
        
        t2=transpose([low:high]);
        %Create a matrix to store this ribbon data
        temp=[ones(size(t2,1),1)*coords(1),ones(size(t2,1),1)*coords(2),t2,coords(3)*ones(size(t2,1),1)];
        %add the new ribbon to the ribbon struct
        app.ribbon(str2double(app.CheckThatDataDropDown.Value)-1).grouped(en+1).grouped=temp;
        %update the ribbon locations(sorted by slice, rather than it's group)
        [app.presynapticPositions,app.postsynapticPositions]=ClusteredToSlice(app.ribbon,app.dimensions);
        %Regraph the ribbons
        addToScatter(app,app.Scat3D,g,on/2);
        %find the slices that have ribbons plotted on them
        indices=find(isgraphics(app.Scat3D(:,1))==1);
        %set the callback for all the new ribbons
        set(app.Scat3D(indices,1),'ButtonDownFcn',{@removeRibbon,app,g});
    end
end

end