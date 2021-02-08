function updateT45auto(obj,event,app)
% 
% updateT45auto(obj,event,app)
%
%   updateT45auto is used to update the graphed associated ribbons and
%   nuclei after having been changed. There is a similar version in the
%   GUI, but this function allows it to be called from anywhere, rather
%   than just in the GUI, which is more useful for dealing with an
%   automatic update after closing the manual input window
% 
%   obj is the figure window
%   event is the window closed callabck
%   app is the GUI object
% 


[app.NAssociated,app.RAssociated]=associateNR(app,app.ribbon,app.newCenters,app.mu,app.voxel,app.UIAxes17,str2double(app.RibbonRadiusEditField.Value));
app.UIAxes17.XLabel.String='X(micron)';
app.UIAxes17.YLabel.String='Y(micron)';
app.UIAxes17.ZLabel.String='Z(micron)';
associatedRun(app);
[app.R1Scat,app.R2Scat]=representNAndR(app.NAssociated,app.RAssociated,app.UIAxes18);
app.UIAxes18.XLabel.String='X(micron)';
app.UIAxes18.YLabel.String='Y(micron)';
app.UIAxes18.ZLabel.String='Z(micron)';
app.channelArray=[app.NucleusChannelEditField.Value,app.PresynapticChannelEditField.Value,app.PostsynapticChannelEditField.Value];
end
