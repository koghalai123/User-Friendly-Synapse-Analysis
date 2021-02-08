function interact = rotateInteractionEdited(varargin)
%ROTATEINTERACTION Create rotate interaction object
%   R = ROTATEINTERACTION creates a RotateInteraction object which enables
%   you to rotate a chart without having to select a button in the axes
%   toolbar. To enable rotating, set the Interactions property of the axes
%   to the object returned by this function. To specify multiple
%   interactions, set the Interactions property to an array of objects. 
%
%   Example:
%       ax = axes;
%       r = rotateInteraction;
%       ax.Interactions = r;

%   Copyright 2018 The MathWorks, Inc.


interact = matlab.graphics.interaction.interactions.RotateInteraction;
