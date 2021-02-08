
% %load in data from a different file that I emailed you
% [voxel,dimensions,minMax,allData]=initialize('6.czi',1,2,3,4);
% 
% %resize image for speed
% imageSize=500;
% [resizedAllData,resizedDimensions,resizedVoxel]=resizeImage(allData,dimensions,voxel,imageSize,imageSize);

function checkData3D(app,allData,chooseOrgCha,nucData,preStruct,postStruct,imageSize,channelVec,~,voxel,dimensions,needSaveBut)


% function checkData3D(app,resizedAllData,chooseOrgCha,nucData,preStruct,postStruct,imageSize,channelVec,resizedDimensions,resizedVoxel,dimensions)
%
% Creates a popup displaying 3D data and organs. 
%
% app is the GUI object
% chooseOrgCha is a number corresponding to the organ that should be shown.
% 1--nuclei 2--Presynaptic 3--Postsynaptic
% nucData is the locations of the nuclei
% preStruct/postStruct is a structure containing pre/postsynaptic locations
% imageSize is how many pixels in the x/y the image is
% resizedDimensions is the size of the data matrix after being resized
% resizedVoxel is the size of a voxel after being resized
% dimensions is the dimensions of the original data


%This line is just to make sure the data has been resized
[resizedAllData,resizedDimensions,resizedVoxel]=resizeImage(allData,dimensions,voxel,500,500);





%User chooses which organ to look at here
organVec=["nucleus","presynaptic","postsynaptic","extra"];
%which channel is associated with each organ
channelVec=[1,2,3,4];
channel=channelVec(chooseOrgCha);
organ=organVec(chooseOrgCha);

%Load in some data from the file that I emailed you with some results
% nucData=saveInOrigForm{2, 1};
% 
% preStruct=saveInOrigForm{2, 2};
% postStruct=saveInOrigForm{2, 3};

voxNucData=nucData(:,1:3)./resizedVoxel;

%data for labelvolshow
opacity=.15;
threshold=.01;



%create two panels
f2=figure;
panVolShow=uipanel(f2,'Position',[0,0,.66,1]);
panOrtho=uipanel(f2,'Position',[.66,0,.33,.9]);

if exist('needSaveBut','var')
    savePanel=uipanel(f2,'Position',[.66,.9,.33,.1]);
    
    saveBut=uicontrol(savePanel,'Style','pushbutton','String','Save Data','Callback',{@saveDataCheck3D,app});
end

%get overlay data for use in labelvolshow. save it as userdata so that it
%can be updated
[finalArr,pixLoc]=getOverlay(voxNucData,preStruct,postStruct,organ,imageSize,resizedVoxel,resizedDimensions,dimensions);
f2.UserData=pixLoc;


%Create labelvolshow and orthosliceviewer objects
volshowView=labelvolshow(uint8(finalArr),resizedAllData(:,:,:,channel),'Parent',panVolShow);
orthoView=orthosliceViewer(resizedAllData(:,:,:,channel),'Parent',panOrtho);
volshowView.VolumeThreshold=threshold;
volshowView.VolumeOpacity=opacity;


%add axes to the labelcolshow figure and add lines so user can see the
%camera target.
a=axes(volshowView.Parent);
a.Position=[0,0,1,1];
a.XLim=[0,1];
a.YLim=[0,1];
set(a,'xtick',[]);
set(a,'xticklabel',[]);
set(a,'ytick',[]);
set(a,'yticklabel',[]);
a.Interactions=[];
l1=line(a,[.5,.5],[0,1]);
l2=line(a,[0,1],[.5,.5]);

%update the camera target to link the labelvolshow and orthosliceviewer
%object. This allows me to move the orthosliceviewer target and have it
%also target the same place on the labelvolshow object
addlistener(f2,'WindowMouseMotion',@(~,~) adjustCamTarg(volshowView,orthoView,resizedDimensions));

%add an organ. Uses a representative size
addOrg=uicontrol(panOrtho,'Style','pushbutton');
addOrg.String={'Add Organ'};
set(addOrg,'Callback',@(~,~) addOrgan(app,f2,orthoView,chooseOrgCha,volshowView,imageSize,resizedVoxel,resizedDimensions,dimensions));
addOrg.Position=[10,10,75,25];

%remove nearest organ
removeOrg=uicontrol(panOrtho,'Style','pushbutton');
removeOrg.String={'Remove Organ'};
set(removeOrg,'Callback',@(~,~) removeOrgan(app,f2,orthoView,chooseOrgCha,volshowView,imageSize,resizedVoxel,resizedDimensions,dimensions));
removeOrg.Position=[85,10,75,25];



ribSearchRange=uicontrol(panOrtho,'Style','edit');
ribSearchRange.String='1';
ribSearchRange.Position=[160,35,120,25];


%not working yet
ribSearch=uicontrol(panOrtho,'Style','pushbutton');
ribSearch.String={'Search for nearby ribbon'};
set(ribSearch,'Callback',@(~,~) ribbonSearch(f2,orthoView,chooseOrgCha,volshowView,ribSearchRange,resizedAllData,imageSize,resizedVoxel,resizedDimensions,dimensions));
ribSearch.Position=[160,10,120,25];


%change the camera target to link the orthosliceviewer and labelvolshow
%objects
function adjustCamTarg(volShowView,orthoView,resizedDimensions)
camCalc=((orthoView.SliceNumbers./(resizedDimensions))-.5);
camTarg=[camCalc(1),camCalc(2),camCalc(3)*resizedDimensions(3)/resizedDimensions(1)];
volShowView.CameraTarget=camTarg;

end
%add representative organ
function addOrgan(app,f2,orthoView,chooseOrgCha,volshowView,imageSize,resizedVoxel,resizedDimensions,dimensions)
f2.UserData=[f2.UserData;orthoView.SliceNumbers];

updateVolume(app,chooseOrgCha,volshowView,f2.UserData,f2.UserData,f2.UserData,imageSize,resizedVoxel,resizedDimensions,dimensions)
end
%remove nearest organ to the crosshair
function removeOrgan(app,f2,orthoView,chooseOrgCha,volshowView,imageSize,resizedVoxel,resizedDimensions,dimensions)
ind=dsearchn(f2.UserData,orthoView.SliceNumbers);
f2.UserData(ind,:)=[];

updateVolume(app,chooseOrgCha,volshowView,f2.UserData,f2.UserData,f2.UserData,imageSize,resizedVoxel,resizedDimensions,dimensions)
end
function ribbonSearch(app,f2,orthoView,chooseOrgCha,volshowView,ribSearchRange,resizedAlldata,imageSize,resizedVoxel,resizedDimensions,dimensions)


searchRange=round(str2double(ribSearchRange.String)./resizedVoxel);
searchMat=[orthoView.SliceNumbers-searchRange;orthoView.SliceNumbers+searchRange];
dataMat=resizedAlldata(searchMat(1,1):searchMat(2,1),searchMat(1,2):searchMat(2,2),searchMat(1,3):searchMat(2,3));
[intensity]=max(max(max(dataMat)));
[r,c,v] = ind2sub(size(dataMat),find(dataMat == intensity));
f2.UserData=[f2.UserData;searchMat(1,:)+[c,r,v]];
updateVolume(app,chooseOrgCha,volshowView,f2.UserData,f2.UserData,f2.UserData,imageSize,resizedVoxel,resizedDimensions,dimensions);
end


%update the volume so that new organs can be added and viewed
function updateVolume(app,chooseOrgCha,volshowView,voxNucData,preStruct,postStruct,imageSize,resizedVoxel,resizedDimensions,dimensions)
organVec2=["nucleus","presynaptic","postsynaptic","extra"];


organ2=(organVec2(chooseOrgCha));
if organ2=='nucleus'
    
    app.newCenters=voxNucData.*resizedVoxel;
    app.mu=3.5*ones(size(voxNucData,1),1);
    
    
elseif organ2=='presynaptic'
%     for i = size(f2.UserData,1)
%         mat=[ones(7,1)*f2.UserData(i,1),ones(7,1)*f2.UserData(i,2),ones(7,1)*f2.UserData(i,3),ones(7,1)*i,];
%         
%     end
elseif organ2=='postsynaptic'
    
else
    disp('data not saved');
end
[finalArr2]=getOverlay(voxNucData,preStruct,postStruct,organ2,imageSize,resizedVoxel,resizedDimensions,dimensions);
setVolume(volshowView,uint8(finalArr2));

end
function saveDataCheck3D(~,~,app)
    
    saveData(app,strcat(num2str(app.fileNum),'final'),[app.newCenters,app.mu],app.UserData,app.voxel,[],[],[],[],app.presynaptic,app.postsynaptic,app.dimensions)
end

end
    
