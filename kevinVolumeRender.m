
%tic
%These two functions are ones that I wrote and did not include in the help
%ticket, but it basically just creates a 4D array of data, comprised of 4
%3D matrices(each of those is a 'channel' that I need to be able to analyze)
%load in some data
[voxel,dimensions,minMax,allData]=initialize('6.czi',1,2,3,4);
%resize it so that it is quicker to graph
 [resizedAllData,resizedDimensions,resizedVoxel]=resizeImage(allData,dimensions,voxel,500,500);

channel=1;

f=figure;
panVolShow=uipanel(f,'Position',[0,0,.66,1]);
panOrthoSliceViewer=uipanel(f,'Position',[.66,0,.34,1]);

%You can choose which channel you want to graph in this line
volIm=volshow(resizedAllData(:,:,:,channel),'Parent',panVolShow);
orthoView=orthosliceViewer(resizedAllData(:,:,:,channel),'Parent',panOrthoSliceViewer);

%all of this just changes some of the properties;
volIm.BackgroundColor=[.1,.1,.1];
colorMat=repmat(transpose(linspace(1,0,256)),1,3);
alphaMat=transpose(linspace(0,1,256));
%alphaMat(1:10,:)=0;
volIm.Colormap=colorMat;
volIm.Alphamap=alphaMat;
%volIm.Renderer='MaximumIntensityProjection';
% volIm.Renderer='Isosurface';
volIm.Isovalue=.10;
% volIm.ScaleFactors=resizedVoxel;



%Add in a few buttons and callbacks for the user to change the channel, as
%well as what type of graph they want
dd=uicontrol(f,'Style','popupmenu');
dd.String={'Normal View','Maximum Intensity Projection','isosurface'};
set(dd,'Callback',{@newGraphType,volIm});
dd.Position=[10,100,100,10];

dd2=uicontrol(f,'Style','popupmenu');
dd2.String={'1','2','3','4'};
set(dd2,'Callback',{@newChannel,volIm,resizedAllData});
dd2.Position=[10,200,100,10];

dd3=uicontrol(f,'Style','edit');
set(dd3,'Callback',{@newIsovalue,volIm});
dd3.Position=[10,300,100,10];

% toc;


%Here is where I start to make my own graph to overlay. And I know that
%volshow has an isosurface feature, but I need to be able to overlay an
%isosurface with the other graphs it has, as well as a few surface graphs
%overlayed with the built in volshow graphs
layers=10;

flooredResized=round(rescale(resizedAllData,1,layers),0);

% volshow(flooredResized(:,:,:,1));
a=axes(volIm.Parent);
hold(a,'on');
% for i = 1:layers
%     C=i/layers;
%     fv=isosurface((flooredResized(:,:,:,2)),i);
%     p(i)=patch(a,fv,'CData',[1-C,1-C,1-C],'FaceAlpha',C/(layers/3),'EdgeColor','none');
% end
nucData=saveInOrigForm{2, 1};
voxNucData=nucData(:,1:3)./resizedVoxel;
[x,y,z]=sphere();
s=gobjects(size(voxNucData,1),1);
for i = 1:size(voxNucData,1)
    s(i)=surf(a,voxNucData(i,1)+x*nucData(i,4)/resizedVoxel(1),voxNucData(i,2)+y*nucData(i,4)/resizedVoxel(2),voxNucData(i,3)+z*nucData(i,4)/resizedVoxel(3));
end
hold(a,'off');
view(a,3);

lineMatX=[0,orthoView.SliceNumbers(2),orthoView.SliceNumbers(3);resizedDimensions(1),orthoView.SliceNumbers(2),orthoView.SliceNumbers(3)];
lineMatY=[orthoView.SliceNumbers(1),0,orthoView.SliceNumbers(3);orthoView.SliceNumbers(1),resizedDimensions(2),orthoView.SliceNumbers(3)];
lineMatZ=[orthoView.SliceNumbers(1),orthoView.SliceNumbers(2),0;orthoView.SliceNumbers(1),orthoView.SliceNumbers(2),resizedDimensions(3)];


lineX=line(a,lineMatX(:,1),lineMatX(:,2),lineMatX(:,3));
lineY=line(a,lineMatY(:,1),lineMatY(:,2),lineMatY(:,3));
lineZ=line(a,lineMatZ(:,1),lineMatZ(:,2),lineMatZ(:,3));




addlistener(f, 'WindowMouseMotion', @(~,~) updateSecondFigure(volIm, a));


%Just the callbacks I referenced earlier
function newGraphType(obj,~,volIm)
graphTypeArr=["VolumeRendering","MaximumIntensityProjection","Isosurface"];
volIm.Renderer=graphTypeArr(obj.Value);

end
function newChannel(obj,~,volIm,resizedAllData)
setVolume(volIm,resizedAllData(:,:,:,obj.Value));

end
function newIsovalue(obj,~,volIm)
volIm.Isovalue=str2double(obj.String);
end
function updateSecondFigure(volIm, a)
 
% Update the Second Figure camera properties to be similar to the
% volshow camera properties

% This is the main code that links the second figure and the volshow
% object
normalizedPos = 4*volIm.CameraPosition ./ norm(volIm.CameraPosition);

% a.CameraPosition = normalizedPos;
% a.CameraUpVector = volIm.CameraUpVector;
% a.CameraTarget = volIm.CameraTarget;
end
