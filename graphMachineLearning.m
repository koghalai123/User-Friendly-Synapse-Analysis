%not used

function [f]=graphMachineLearning(graphObj,scatterObj)
f=uifigure;
ax=uiaxes(f);



hold(ax,'on');
colormap(ax,'gray');

P1=copyobj(graphObj,ax);



for i = 1:size(scatterObj.XData,2)
    
    plot_handles(i)=plot(ax, scatterObj.XData(1,i), scatterObj.YData(1,i), 'o', 'MarkerSize', 10,'Color','r');
end

set(f, 'WindowButtonDownFcn', @figure_button_down);
set(plot_handles, 'ButtonDownFcn', {@circle_selected});


    function figure_button_down(fig, ~)
        ax_max_x = ax.InnerPosition(1) + ax.InnerPosition(3); % max mouse X pos inside axis
        ax_max_y = ax.InnerPosition(2) + ax.InnerPosition(4); % max mouse Y pos inside axis
        
        % Determines if the user clicked on the UIAxes
        if  strcmpi(fig.SelectionType, 'open') &&...% CurrentObject is not a circle or other control
           ... % if it is a double-click event       %%%%strcmpi(fig.SelectionType, 'open') &&
           fig.CurrentPoint(1) >= ax.InnerPosition(1) &&... % <<< these 4 lines for determining if clicked inside the axis
           fig.CurrentPoint(1) <= ax_max_x &&...            %   CurrentPosition: mouse click X and Y
           fig.CurrentPoint(2) >= ax.InnerPosition(2) &&... %   InnerPosition: axis position and size (x0,y0,width,height)
           fig.CurrentPoint(2) <= ax_max_y                  % >>>
            % Inside axis & double-click!
            new_circle_x = ax.XLim(2) * (fig.CurrentPoint(1) - ax.InnerPosition(1))/ax.InnerPosition(3);
            new_circle_y = ax.YLim(2) * (fig.CurrentPoint(2) - ax.InnerPosition(2))/ax.InnerPosition(4);
            plot_handles(end+1) = plot(ax, new_circle_x, new_circle_y, ...
                                       'o', 'MarkerSize', 10,'Color','r');
            set(plot_handles(end), 'ButtonDownFcn', {@circle_selected});
        end
    end

    function circle_selected(plot_handle, event_data)
        switch event_data.Button
            case 1  % highlight the selected line
%                 set(plot_handle, 'LineWidth', 2.5);
%                 set(plot_handles(plot_handles ~= plot_handle), 'LineWidth', 0.5);
            case 2  % add a random line
                disp('do something else...');
            case 3  % remove the selected line
                delete(plot_handle);
                plot_handles(plot_handles == plot_handle) = [];
        end
    end
    S1=transpose([plot_handles(:).XData;plot_handles(:).YData]);





end