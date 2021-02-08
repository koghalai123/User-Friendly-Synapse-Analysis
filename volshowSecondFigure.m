function volshowSecondFigure

hfig = figure;
load(fullfile(toolboxdir('images'),'imdata','BrainMRILabeled','images','vol_001.mat'));

% Panel for volshow
volumePanel = uipanel('Parent',hfig,...
    'Position',[0.05 0.05 0.45 0.45]);

hvolshow = volshow(vol,'Parent',volumePanel);

% Create Second Figure axes
hSecondFigure = createSecondFigure(hfig, hvolshow);

% Add a Mouse Motion listener to the figure.
% Update the Second Figure's Camera properties whenever the mouse is
% moved on the figure
addlistener(hfig, 'WindowMouseMotion', @(~,~) updateSecondFigure(hvolshow, hSecondFigure));

end


function updateSecondFigure(hvolshow, hSecondFigure)
 
% Update the Second Figure camera properties to be similar to the
% volshow camera properties

% This is the main code that links the second figure and the volshow
% object
normalizedPos = 4*hvolshow.CameraPosition ./ norm(hvolshow.CameraPosition);

hSecondFigure.CameraPosition = normalizedPos;
hSecondFigure.CameraUpVector = hvolshow.CameraUpVector;
hSecondFigure.CameraTarget = hvolshow.CameraTarget;
            
end


function hAx = createSecondFigure(hfig, hvolshow)

% This function is used to create the Second Figure GUI.
% This can be replaced with any other GUI as well

hPanel = uipanel('Parent',hfig,...
    'Units','Normalized',...
    'Position',[0.5 0.05 0.45 0.45]);

hAx = axes('Parent',hPanel,...
    'Units','Normalized',...
    'Position', [0 0 1 1],...
    'Visible','off',...
    'Clipping','off',...
    'ClippingStyle','3dbox',...
    'CameraPositionMode','manual');
axis(hAx,'equal');
hAx.Camera.DepthSort = 'off';

totalLength = 4; % Line  + Text
hAx.XLim = [-totalLength totalLength] + [-0.5 0.5];
hAx.YLim = [-totalLength totalLength] + [-0.5 0.5];
hAx.ZLim = [-totalLength totalLength] + [-0.5 0.5];

% %% Example of graphing a function on second axes
syms f(x,y)
f(x,y)=real(atan(x+i*y));
ezsurf(f)

%% Example of displaying orientation axis labels on second axes
% line('Parent',hAx,'XData',[0 totalLength-1],'YData',[0 0],'ZData',[0 0],...
%     'LineWidth',2);
% line('Parent',hAx,'XData',[0 0],'YData',[0 totalLength-1],'ZData',[0 0],...
%     'LineWidth',2);
% line('Parent',hAx,'XData',[0 0],'YData',[0 0],'ZData',[0 totalLength-1],...
%     'LineWidth',2);
% textLoc = totalLength ;
% text(hAx,textLoc,0,0,'X');
% text(hAx,0,textLoc,0,'Y');
% text(hAx,0,0,textLoc,'Z');

% Set the second figure's camera properties to be same as the volshow
% Camera properties
updateSecondFigure(hvolshow, hAx);

end