function [finalArr,pixLoc]=getOverlay(voxNucData,preStruct,postStruct,organ,imageSize,resizedVoxel,resizedDimensions,dimensions)
%
% function [finalArr,pixLoc]=getOverlay(voxNucData,preStruct,postStruct,organ,imageSize,resizedVoxel,resizedDimensions,dimensions)
%
% getOverlay takes in organs and uses size measurements to plot them on a
% rendered 3D image
%
% voxNucData is the nucleus data in actual distance
% pre/postStruct is a structure containing synapses found on each slice
% organ is a string with what organ is being looked at
% imageSize is the size of the x/y limits
% resized Voxel is the size of the voxels after being resized
% resizedDimensions is the size of the image after being resized
% dimensions is the size of the original image

meshX=[];
meshY=[];
meshZ=[];
[x,y,z]=sphere();
fvc=surf2patch(x,y,z,'triangles');

for i =1:size(fvc.faces,1)




    meshX(i,:)=fvc.vertices(fvc.faces(i,:),1);
    meshY(i,:)=fvc.vertices(fvc.faces(i,:),2);
    meshZ(i,:)=fvc.vertices(fvc.faces(i,:),3);

end
if organ=="nucleus"
    rad=2;
    xRange=round(rad/resizedVoxel(1));
    yRange=round(rad/resizedVoxel(2));
    zRange=round(rad/resizedVoxel(3));

    temp=VOXELISE(2*xRange+1,2*yRange+1,2*zRange+1,meshX',meshY',meshZ');
    pixLoc=voxNucData;
    roundedNucData=round(voxNucData);
    buffer=10;
    finalArrWBuff=false(resizedDimensions(1)+2*buffer,resizedDimensions(2)+2*buffer,resizedDimensions(3)+2*buffer);
    for j = 1:size(voxNucData,1)


        finalArrWBuff(roundedNucData(j,2)-yRange+buffer:roundedNucData(j,2)+yRange+buffer,roundedNucData(j,1)-xRange+buffer:roundedNucData(j,1)+xRange+buffer,roundedNucData(j,3)-zRange+buffer:roundedNucData(j,3)+zRange+buffer)=finalArrWBuff(roundedNucData(j,2)-yRange+buffer:roundedNucData(j,2)+yRange+buffer,roundedNucData(j,1)-xRange+buffer:roundedNucData(j,1)+xRange+buffer,roundedNucData(j,3)-zRange+buffer:roundedNucData(j,3)+zRange+buffer) | temp;
    end
            finalArr=finalArrWBuff(buffer+1:buffer+resizedDimensions(1),buffer+1:buffer+resizedDimensions(2),buffer+1:buffer+resizedDimensions(3));

elseif organ=="presynaptic"
    rad=.15;
    xRange=round(rad/resizedVoxel(1));
    yRange=round(rad/resizedVoxel(2));
    zRange=round(rad/resizedVoxel(3));

    temp=VOXELISE(2*xRange+1,2*yRange+1,2*zRange+1,meshX',meshY',meshZ');
    if class(preStruct)=='struct'
        pixLoc=round(findSynapseLocationsFromStruct(preStruct).*resizedDimensions./dimensions);
        roundedPreData=pixLoc;
    elseif class(preStruct)=='double'
        roundedPreData=preStruct;
    end

    buffer=5;
    finalArrWBuff=false(resizedDimensions(1)+2*buffer,resizedDimensions(2)+2*buffer,resizedDimensions(3)+2*buffer);
    for j = 1:size(roundedPreData,1)


        finalArrWBuff(roundedPreData(j,2)-yRange+buffer:roundedPreData(j,2)+yRange+buffer,roundedPreData(j,1)-xRange+buffer:roundedPreData(j,1)+xRange+buffer,roundedPreData(j,3)-zRange+buffer:roundedPreData(j,3)+zRange+buffer)=finalArrWBuff(roundedPreData(j,2)-yRange+buffer:roundedPreData(j,2)+yRange+buffer,roundedPreData(j,1)-xRange+buffer:roundedPreData(j,1)+xRange+buffer,roundedPreData(j,3)-zRange+buffer:roundedPreData(j,3)+zRange+buffer) | temp;
    end

        finalArr=finalArrWBuff(buffer+1:buffer+resizedDimensions(1),buffer+1:buffer+resizedDimensions(2),buffer+1:buffer+resizedDimensions(3));

elseif organ=="postsynaptic"
    rad=.125;
    xRange=round(rad/resizedVoxel(1));
    yRange=round(rad/resizedVoxel(2));
    zRange=round(rad/resizedVoxel(3));

    temp=VOXELISE(2*xRange+1,2*yRange+1,2*zRange+1,meshX',meshY',meshZ');
    if class(postStruct)=='struct'

        pixLoc=round(findSynapseLocationsFromStruct(postStruct).*resizedDimensions./dimensions);
        roundedPostData=pixLoc;
    elseif class(postStruct)=='double'
        roundedPostData=postStruct;
    end
    buffer=5;
    finalArrWBuff=false(resizedDimensions(1)+2*buffer,resizedDimensions(2)+2*buffer,resizedDimensions(3)+2*buffer);
    for j = 1:size(roundedPostData,1)


        finalArrWBuff(roundedPostData(j,2)-yRange+buffer:roundedPostData(j,2)+yRange+buffer,roundedPostData(j,1)-xRange+buffer:roundedPostData(j,1)+xRange+buffer,roundedPostData(j,3)-zRange+buffer:roundedPostData(j,3)+zRange+buffer)=finalArrWBuff(roundedPostData(j,2)-yRange+buffer:roundedPostData(j,2)+yRange+buffer,roundedPostData(j,1)-xRange+buffer:roundedPostData(j,1)+xRange+buffer,roundedPostData(j,3)-zRange+buffer:roundedPostData(j,3)+zRange+buffer) | temp;
    end
        finalArr=finalArrWBuff(buffer+1:buffer+resizedDimensions(1),buffer+1:buffer+resizedDimensions(2),buffer+1:buffer+resizedDimensions(3));
    
elseif organ=="extra"
    finalArr=false(resizedDimensions(1),resizedDimensions(2),resizedDimensions(3));
    pixLoc=[];
end