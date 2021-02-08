f=figure;
a=axes(f);
nucData=saveInOrigForm{2, 1};
voxNucData=nucData(:,1:3)./resizedVoxel;
[x,y,z]=sphere();
s=gobjects(size(voxNucData,1),1);
L=zeros(size(resizedAllData,1),size(resizedAllData,2),size(resizedAllData,3));
surfPoints=[];
hold(a,'on');
for i = 1:size(voxNucData,1)
%     surfPoints(:,:,:,i)=cat(3,voxNucData(i,1)+x*nucData(i,4)/resizedVoxel(1),voxNucData(i,2)+y*nucData(i,4)/resizedVoxel(2),voxNucData(i,3)+z*nucData(i,4)/resizedVoxel(3));
%     gridX = uint16(voxNucData(i,1)+x(:)*nucData(i,4)/resizedVoxel(1));
%     gridY = uint16(voxNucData(i,2)+y(:)*nucData(i,4)/resizedVoxel(2));
%     gridZ = uint16(voxNucData(i,3)+z(:)*nucData(i,4)/resizedVoxel(3));
%     gridOutput = VOXELISE(gridX, gridY, gridZ);
    s(i)=surf(voxNucData(i,1)+x*nucData(i,4)/resizedVoxel(1),voxNucData(i,2)+y*nucData(i,4)/resizedVoxel(2),voxNucData(i,3)+z*nucData(i,4)/resizedVoxel(3));
    %     BW=multiVoxelElipsoidCreator(transpose(nucData(:,4)), voxNucData, repmat(1./resizedVoxel,size(nucData,1),1));
%      L(temp(:,:,i))=1;
%plotVoxelArray(resizedAllData(:,:,:,1))

end
hold(a,'off');
%plotVoxelArray(resizedAllData(:,:,:,1))
view(3)
surf2patch(s)
% volIm2=labelvolshow(BW);
% volIm2.VolumeOpacity=.25;
% volIm2.VolumeThreshold=.09;