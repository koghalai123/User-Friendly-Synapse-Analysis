function graphLine(UIAxes,range,dataSize)
% 
% function graphLine(UIAxes,range,dataSize)
%
% graphLine graphs two lines across the screen like crosshairs. This allows
% the user to see the focus point of the camera
%
% UIAxes are the axes that the line will be graphed on
% range is a matrix with 1/2 of the size of the image
% dataSize is a scalar with the length of the x/y
%
line(UIAxes,[0,dataSize],[range(1),range(1)]);
line(UIAxes,[0,dataSize],[range(2),range(2)]);

end