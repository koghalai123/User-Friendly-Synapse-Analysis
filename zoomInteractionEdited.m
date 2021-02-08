function interact = zoomInteractionEdited(varargin)
%ZOOMINTERACTION Create zoom interaction object
%   Z = ZOOMINTERACTION creates a ZoomInteraction object which enables you
%   to zoom by scrolling or pinching within a chart without having to
%   select a button in the axes toolbar. To enable zooming, set the
%   Interactions property of the axes to the object returned by this
%   function. To specify multiple interactions, set the Interactions
%   property to an array of objects. 
%
%   Z = ZOOMINTERACTION('Dimensions',d) constrains zooming to the specified
%   dimensions. 
%
%   Example:
%       ax = axes;
%       z = zoomInteraction;
%       ax.Interactions = z;

%   Copyright 2018 The MathWorks, Inc.

res = matlab.graphics.interaction.internal.parseInteractionInputs(varargin{:});

interact = matlab.graphics.interaction.interactions.ZoomInteraction;
interact.Dimensions = res.Dimensions;