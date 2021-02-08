% Copyright 2018-2019 The MathWorks, Inc.
classdef (Sealed, ConstructOnLoad) volshowFromMat < handle & matlab.mixin.SetGet & ...
        matlab.graphics.mixin.internal.GraphicsDataTypeContainer
properties (Dependent)
        % Parent - Parent
        %   Parent is specified as a handle to a uipanel or figure. When
        %   no parent is provided, the volshow object is parented to gcf.
        %
        Parent
        
        % Alphamap - Transparency map
        %   Transparency map for the volume content, specified as a 256x1
        %   numeric array, with values in the range [0 1]. The default
        %   alphamap is equal to linspace(0,1,256)'.
        %
        Alphamap
        
        % Colormap - Color map
        %   Colormap of the volume content, specified as a 256x3 numeric
        %   array, with values in the range [0 1]. The default colormap is
        %   equal to colormap(gray(256)).
        %
        Colormap
        
        % Lighting - Effects of light object
        %   Light present, specified as a logical scalar. This property
        %   specifies whether to render the effects of a light source.
        Lighting
        
        % IsosurfaceColor - Color of isosurface
        %   Isosurface color, specified as a MATLAB ColorSpec, with values
        %   in the range [0 1]. This property specifies the volume color
        %   when the Renderer is set to 'Isosurface'.
        %
        IsosurfaceColor
        
        % Isovalue - Value defining isosurface
        %
        Isovalue
        
        % Renderer - Rendering style
        %   Rendering style, specified as one of these values:
        %
        %   'VolumeRendering' - View the volume based on the specified
        %   color and transparency for each voxel.
        %
        %   'MaximumIntensityProjection' - View the voxel with the
        %   highest intensity value for each ray projected through the
        %   data.
        %
        %   'Isosurface' - View an isosurface of the volume specified by
        %   the value in Isovalue.
        %
        %   When the volume is logical, the default Renderer is
        %   'Isosurface', otherwise the default Renderer is
        %   'VolumeRendering'.
        %
        Renderer
        
        % CameraPosition - Camera location
        %   Location of camera, or the viewpoint, specified as a
        %   three-element vector of the form [x y z]. Changing the
        %   CameraPosition property changes the point from which you view
        %   the volume. The camera is oriented along the view axis, which
        %   is a straight line that connects the camera position and the
        %   camera target. Default value is [4 4 2.5]. Interactively
        %   rotating the volume will modify this property.
        %
        CameraPosition
        
        % CameraUpVector - Vector defining upwards direction
        %   Vector defining upwards direction, specified as a three-element
        %   direction vector of the form  [x y z]. Default value is [0 0
        %   1]. Interactively rotating the volume will modify this
        %   property.
        %
        CameraUpVector
        
        % CameraTarget - Camera target point
        %   Point used as camera target, specified as a three-element
        %   vector of the form [x y z]. The camera is oriented along the
        %   view axis, which is a straight line that connects the camera
        %   position and the camera target. The default value is [0 0 0].
        %
        CameraTarget
        
        % CameraViewAngle - Field of view
        % Field of view, specified as a scalar angle greater than or equal
        % to 0 and less than 180. The greater the angle, the larger the
        % field of view and the smaller objects appear in the scene.
        % Default value is 15.
        %
        CameraViewAngle
        
        % BackgroundColor - Background color
        %   Color of the background, specified as a MATLAB ColorSpec. The
        %   intensities must be in the range [0,1]. The default color is
        %   [0.3 0.75 0.93].
        %
        BackgroundColor
        
        % ScaleFactors - Volume scale factors
        %   Scale factors used to rescale volume, specified as a [1x3]
        %   positive numeric array. The values in the array correspond to
        %   the scale factor applied in the x, y, and z direction. Default
        %   value is [1 1 1].
        %
        ScaleFactors
        
        % InteractionsEnabled - Control interactivity
        %   Interactivity of the volume. When true (default), you can zoom
        %   using the mouse scroll wheel, and rotate by clicking and
        %   dragging on the volume. Rotation and zoom is performed about
        %   the value specified by CameraTarget. When false, you cannot
        %   interact with the volume.
        %
        InteractionsEnabled
        
    end
    
    properties (Transient, Hidden = true, GetAccess = public, SetAccess = protected)
        Type matlab.internal.datatype.matlab.graphics.datatype.TypeName = 'volshow';
    end
    
    properties (Access = public)
        
        viewerView
        viewerModel
        viewerController
        
        InteractableInternal = true;
        
    end
    
    properties (Transient, Access = private)
        
        LifeCycleListener
        
    end
    
    methods
        
        %------------------------------------------------------------------
        %  volshow
        %------------------------------------------------------------------
        function self = volshowFromMat(V,varargin)
            
            % Check for openGL Drivers
            images.internal.app.volview.checkOpenGLDrivers();
            
            % Verify volume is 3D
            if ~images.internal.app.volview.isVolume(V)
                error(message('images:volumeViewer:requireVolumeData'));
            end
            
            supportedImageClasses    = {'int8','uint8','int16','uint16','int32','uint32','single','double','logical'};
            supportedImageAttributes = {'real','nonsparse','nonempty'};
            validateattributes(V,supportedImageClasses,supportedImageAttributes,mfilename,'V');
            
            % Hardware OpenGL is required for isosurface
            if islogical(V) && ~iptgetpref('VolumeViewerUseHardware')
                error(message('images:volumeViewer:hardwareRequired'));
            end
            
            % Create Model and load volume
            self.viewerModel = images.internal.app.volview.Model();
            self.viewerModel.loadNewVolumeData(V,'volume');
            
            % Check for volshow(V,config)
            if ~isempty(varargin) && ~ischar(varargin{1}) && ~isstring(varargin{1})
                config = varargin{1};
                validateattributes(config, {'struct'},{'nonempty','scalar'},mfilename,'CONFIG')
                varargin = varargin(2:end);
                
                fields = fieldnames(config);
                for i = 1:numel(fields)
                    set(self,fields{i},config.(fields{i}));
                end
            end
            
            % Parse Name/Value pairs
            parseInputs(self,varargin{:});
            
            set(self.viewerView.VolumePanel,'Visible','on');
            
        end
        
        %------------------------------------------------------------------
        %  setVolume
        %------------------------------------------------------------------
        function setVolume(self,V)
            %setVolume - set volume in volshow object
            % setVolume(hVol,V) updates the volshow object hVol with a new
            % volume V. When setVolume is used, the current viewpoint will
            % be preserved other visualization settings remain unchanged.
            
            % Verify volume is 3D
            if ~images.internal.app.volview.isVolume(V)
                error(message('images:volumeViewer:requireVolumeData'));
            end
            
            supportedImageClasses    = {'int8','uint8','int16','uint16','int32','uint32','single','double','logical'};
            supportedImageAttributes = {'real','nonsparse','nonempty'};
            validateattributes(V,supportedImageClasses,supportedImageAttributes,mfilename,'V');
            
            self.viewerModel.loadVolumeData(V,'volume');
            
        end
        
    end
    
    methods (Access = private)
        
        function parseInputs(self,varargin)
            
            varargin = matlab.images.internal.stringToChar(varargin);
            
            % Get axes handle
            if ~isempty(varargin)
                
                % Extract the Interaction Name/Value pair. Set it last
                [hInteract, varargin] = extractInputNameValue(varargin, 'InteractionsEnabled');
                
                % Extract the ScaleFactors Name/Value pair. Set it second to last
                [hScale, varargin] = extractInputNameValue(varargin, 'ScaleFactors');
                
                % Extract the Parent Name/Value pair. Set it after all
                % other remaining pairs
                [hParent, varargin] = extractInputNameValue(varargin, 'Parent');
                
                % Set all other Name/Value pairs. The order does not matter
                if ~isempty(varargin)
                    set(self, varargin{:});
                end
                
                % Now set the Parent. Setting the parent will blow away any
                % existing View/Controller and wire up new ones.
                if isempty(hParent)
                    hFig = gcf;
                    removeToolbarFromFigure(hFig);
                    self.Parent = hFig;
                else
                    self.Parent = hParent;
                end
                
                if ~isempty(hScale)
                    self.ScaleFactors = hScale;
                end
                
                if ~isempty(hInteract)
                    self.InteractionsEnabled = hInteract;
                end
                
            else
                % No Name/Value pairs, use gcf as Parent
                hFig = gcf;
                removeToolbarFromFigure(hFig);
                self.Parent = hFig;
            end
            
        end
        
        function attachVolshowToParent(self)
            
            if ~isempty(self.Parent)
                
                hParent = self.Parent;
                
                % If the parent does not have this hidden property, add it.
                if ~isprop(hParent,'IPTVolshowManager')
                    iptVolshowManager = hParent.addprop('IPTVolshowManager');
                    iptVolshowManager.Hidden = true;
                    iptVolshowManager.Transient = true;
                end
                
                % The property will keep a reference to the volshow object.
                % This should not add any additional memory, but will keep
                % the volshow object from being destroyed if the user loses
                % all references to the object in the workspace. This is 
                % done to be consistent with typical HG object behavior.
                hParent.IPTVolshowManager = self;
                
                % Add a life cycle listener to delete the volshow object
                % when the parent is deleted. This is done to be consistent
                % with typical HG object behavior.
                self.LifeCycleListener = addlistener(hParent,'ObjectBeingDestroyed', @(~,~) delete(self));
                
            end
            
        end
        
        function detachVolshowFromParent(self)
            
            if ~isempty(self.Parent)
                
                hParent = self.Parent;
                
                % If the parent is keeping a reference to the volshow
                % handle, remove it.
                if isprop(hParent,'IPTVolshowManager')
                    hParent.IPTVolshowManager = [];
                end
                
                % Delete the life cycle listener
                delete(self.LifeCycleListener);
                
            end
            
        end
        
        function updateProperties(self,TF)
            
            % Update background color
            self.BackgroundColor = self.BackgroundColor;
            
            % Update volume primitive by triggering VolumeDataChangeEventData
            self.viewerModel.triggerVolumeDataChange();
            
            % Update all rendering settings
            self.Renderer = self.Renderer;
            
            % Update camera positioning
            self.CameraPosition = self.CameraPosition;
            
            % Update scale factors
            self.ScaleFactors = self.ScaleFactors;
            
            self.InteractionsEnabled = TF;
        end
        
    end
    
    methods
        % Set/Get methods
        
        %------------------------------------------------------------------
        %  Parent
        %------------------------------------------------------------------
        function set.Parent(self,hPanel)
            
            if isempty(hPanel) || ~isvalid(hPanel)
                error(message('images:volumeViewer:invalidParent'));
            end
            
            if ~isa(hPanel,'matlab.ui.Figure') && ~isa(hPanel,'matlab.ui.container.Panel')
                error(message('images:volumeViewer:parentNotSupported'));
            end
            
            hFig = ancestor(hPanel,'figure');
            if strcmp(hFig.Renderer,'painters')
                error(message('images:volumeViewer:paintersRenderer'));
            end
            
            if isempty(self.viewerController)
                TF = true;
            else
                detachVolshowFromParent(self);
                TF = self.InteractionsEnabled;
            end
            
            delete(self.viewerView);
            self.viewerView = [];
            
            delete(self.viewerController);
            self.viewerController = [];
            
            self.viewerView  = images.internal.volshow.View();
            
            % Set up panel and initial viewpoint
            if isa(hPanel,'matlab.ui.container.Panel')
                % If parent is panel, then use that panel
                self.viewerView.VolumePanel = hPanel;
            elseif isa(hPanel,'matlab.ui.Figure')
                % If parent is figure, then create panel as child
                self.viewerView.VolumePanel = uipanel('Parent',hPanel,'BorderType','none','Visible','off','HandleVisibility','off');
            else
                % If no parent is specified, create new figure
                hFig = figure;
                self.viewerView.VolumePanel = uipanel('Parent',hFig,'BorderType','none','Visible','off','HandleVisibility','off');
            end
            
            self.viewerView.createView();
            self.viewerController = images.internal.volshow.Controller(self.viewerModel,self.viewerView);
            
            updateProperties(self,TF);
            
            hFig = ancestor(self.viewerView.VolumePanel,'figure');
            set(self.viewerView.VolumePanel,'Visible','on');
            
            % Volume rendering is not supported with painters. Explicitly
            % set to opengl
            set(hFig,'Renderer','opengl');
            
            set(hFig,'Visible','on');
            
            attachVolshowToParent(self);
            
        end
        
        function hPanel = get.Parent(self)
            hPanel = self.viewerView.VolumePanel;
        end
        
        %------------------------------------------------------------------
        %  Camera Position
        %------------------------------------------------------------------
        function set.CameraPosition(self,val)
            validateattributes(val,{'numeric'},...
                {'size',[1 3],'real','finite','nonempty','nonsparse'},...
                mfilename,'CameraPosition');
            self.viewerModel.CameraPosition = val;
        end
        
        function val = get.CameraPosition(self)
            val = self.viewerModel.CameraPosition;
        end
        
        %------------------------------------------------------------------
        %  Camera Up Vector
        %------------------------------------------------------------------
        function set.CameraUpVector(self,val)
            validateattributes(val,{'numeric'},...
                {'size',[1 3],'real','finite','nonempty','nonsparse'},...
                mfilename,'CameraUpVector');
            self.viewerModel.CameraUpVector = val;
        end
        
        function val = get.CameraUpVector(self)
            val = self.viewerModel.CameraUpVector;
        end
        
        %------------------------------------------------------------------
        %  Camera Target
        %------------------------------------------------------------------
        function set.CameraTarget(self,val)
            validateattributes(val,{'numeric'},...
                {'size',[1 3],'real','finite','nonempty','nonsparse'},...
                mfilename,'CameraTarget');
            self.viewerModel.CameraTarget = val;
        end
        
        function val = get.CameraTarget(self)
            val = self.viewerModel.CameraTarget;
        end
        
        %------------------------------------------------------------------
        %  Camera View Angle
        %------------------------------------------------------------------
        function set.CameraViewAngle(self,val)
            self.viewerModel.CameraViewAngle = val;
        end
        
        function val = get.CameraViewAngle(self)
            val = self.viewerModel.CameraViewAngle;
        end
        
        %------------------------------------------------------------------
        %  Background Color
        %------------------------------------------------------------------
        function set.BackgroundColor(self,newColor)
            self.viewerModel.BackgroundColor = convertColorSpec(images.internal.ColorSpecToRGBConverter,newColor);
        end
        
        function color = get.BackgroundColor(self)
            color = self.viewerModel.BackgroundColor;
        end
        
        %------------------------------------------------------------------
        %  Renderer
        %------------------------------------------------------------------
        function set.Renderer(self,renderStr)
            % Input validation happens in the Model
            self.viewerModel.Renderer = renderStr;
        end
        
        function renderStr = get.Renderer(self)
            renderStr = self.viewerModel.Renderer;
        end
        
        %------------------------------------------------------------------
        %  Isovalue
        %------------------------------------------------------------------
        function set.Isovalue(self,isoval)
            % Input validation happens in the Model
            self.viewerModel.setIsovalue(isoval);
        end
        
        function isoval = get.Isovalue(self)
            isoval = self.viewerModel.getIsovalue;
        end
        
        %------------------------------------------------------------------
        %  Isosurface Color
        %------------------------------------------------------------------
        function set.IsosurfaceColor(self,c)
            self.viewerModel.setIsosurfaceColor(convertColorSpec(images.internal.ColorSpecToRGBConverter,c));
        end
        
        function c = get.IsosurfaceColor(self)
            c = self.viewerModel.getIsosurfaceColor;
        end
        
        %------------------------------------------------------------------
        %  Alpha Map
        %------------------------------------------------------------------
        function set.Alphamap(self,alphaMapIn)
            validateattributes(alphaMapIn,{'numeric'},...
                {'size',[256,1],'finite','nonnegative','nonsparse','nonempty','real','<=',1},...
                mfilename,'Alphamap');
            self.viewerModel.setAlphamapVol(double(alphaMapIn'));
        end
        
        function alphaMapIn = get.Alphamap(self)
            alphaMapIn = self.viewerModel.getAlphamap;
            alphaMapIn = alphaMapIn';
        end
        
        %------------------------------------------------------------------
        %  Color Map
        %------------------------------------------------------------------
        function set.Colormap(self,colorMapIn)
            validateattributes(colorMapIn,{'numeric'},...
                {'size',[256,3],'finite','nonnegative','nonsparse','nonempty','real','<=',1},...
                mfilename,'Colormap');
            self.viewerModel.setColormapVol(double(colorMapIn));
        end
        
        function colorMapIn = get.Colormap(self)
            colorMapIn = self.viewerModel.getColormap;
        end
        
        %------------------------------------------------------------------
        %  Lighting
        %------------------------------------------------------------------
        function set.Lighting(self,lighting)
            if isnumeric(lighting)
                lighting = logical(lighting);
            end
            validateattributes(lighting,{'logical'},{'scalar','nonempty'},...
                mfilename,'Lighting');
            self.viewerModel.setLighting(lighting);
        end
        
        function lighting = get.Lighting(self)
            lighting = self.viewerModel.getLighting;
        end
        
        %------------------------------------------------------------------
        %  Scale Factors
        %------------------------------------------------------------------
        function set.ScaleFactors(self,scaleFactors)
            
            validateattributes(scaleFactors,{'numeric'},...
                {'size',[1 3],'real','finite','nonempty','nonsparse','positive'},...
                mfilename,'ScaleFactors');
            
            % Get the current transform
            tform = self.viewerModel.Transform;
            
            % Add the proposed scale factors
            tform(1,1) = scaleFactors(1);
            tform(2,2) = scaleFactors(2);
            tform(3,3) = scaleFactors(3);
            
            % Set the transform in the model
            self.viewerModel.Transform = tform;
            self.viewerModel.CustomTransform = tform;
            
        end
        
        function scaleFactors = get.ScaleFactors(self)
            scaleFactors = [self.viewerModel.Transform(1,1),...
                self.viewerModel.Transform(2,2),...
                self.viewerModel.Transform(3,3)];
        end
        
        %------------------------------------------------------------------
        %  Interactions Enabled
        %------------------------------------------------------------------
        function set.InteractionsEnabled(self,TF)
            
            validateattributes(TF,{'logical','numeric'},...
                {'nonempty','real','scalar','nonsparse'},...
                mfilename,'InteractionsEnabled');
            
            self.viewerController.CameraController.Interactable = logical(TF);
            
        end
        
        function TF = get.InteractionsEnabled(self)
            TF = self.viewerController.CameraController.Interactable;
        end
        
    end
    
end

%--Remove Toolbar From Figure----------------------------------------------
function removeToolbarFromFigure(hFig)

% Strip toolbar of incompatible features
hFig.MenuBar = 'none';
hFig.ToolBar = 'figure';

hObjects = findall(hFig,'Tag','Exploration.Brushing','-or',...
    'Tag','Standard.OpenInspector','-or',...
    'Tag','DataManager.Linking','-or',...
    'Tag','Annotation.InsertColorbar','-or',...
    'Tag','Plottools.PlottoolsOn','-or',...
    'Tag','Plottools.PlottoolsOff','-or',...
    'Tag','Standard.EditPlot','-or',...
    'Tag','Annotation.InsertLegend');

arrayfun(@(h) set(h,'Separator','off'),hObjects);
arrayfun(@(h) set(h,'Visible','off'),hObjects);

end

%--Extract Input Name Value----------------------------------------
function [propvalue, inputs] = extractInputNameValue(inputs, propname)

index = [];

for p = 1:2:length(inputs)

    % Look for the parameter amongst the possible values.
    name  = inputs{p};
    TF = strncmpi(name, propname, numel(name));
    
    if TF
        index = p;
    end

end

if isempty(index)
    propvalue = [];
else
    % Guard against using Parent as a N/V pair more than once
    propvalue = inputs{index(end)+1};
    inputs([index index+1]) = [];
end

end