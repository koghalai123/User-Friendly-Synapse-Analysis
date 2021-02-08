%not used

for fileNum=1:287
    
    fileName=strcat(num2str(fileNum),'C4.tif');
    storageLocation=strcat('F:\RibbonAnalysisDataSets\tiffData\',num2str(fileNum),'RawData');
    voxelStorageLocation=strcat('F:\RibbonAnalysisDataSets\Final\',num2str(fileNum),'Final');
    voxelFileName=strcat(num2str(fileNum),'FinalMat.mat');
    
    movefile(strcat(voxelStorageLocation,'\',voxelFileName));
    load(voxelFileName);
    voxel=saveInOrigForm{2, 13};
    movefile(voxelFileName,voxelStorageLocation);
    
    movefile(strcat(storageLocation,'\',fileName));
    info = imfinfo(fileName);
    stackHeight=size(info,1);
    row=info(1).Height;
    col=info(1).Width;
    
    for j = 1:stackHeight
        phalloidenData(:,:,j)=(imread(fileName,j));
    end
    
    movefile(fileName,storageLocation);
    
    rescaled=rescale(phalloidenData);
    converted2D=rescaled(:,:);
    hist=imhist(converted2D);
    totalPixels=sum(hist);
    thresh=find(hist>totalPixels/1000, 1, 'last' )/255;
    thresholded=rescaled>thresh;
    
    filtered=medfilt3(thresholded,[5,5,3]);
    
    cc=struct();
    coords=struct();
    minSize=25;
    maxSize=50;
    labeled=zeros(size(filtered,1),size(filtered,2),size(filtered,3));
    
    
    for i =1:size(filtered,3)
        counter=1;
        cc(i).connected=bwconncomp(filtered(:,:,i));
        for j=1:size(cc(i).connected.PixelIdxList,2)
            numPoints=size(cc(i).connected.PixelIdxList{1,j},1);
            if numPoints>minSize && numPoints<maxSize
                coords(i).slice(counter).size=numPoints;
                [row,col]=ind2sub([2048,2048],cc(i).connected.PixelIdxList{1,j});
                coords(i).slice(counter).coords=[row,col];
                labeled(row,col,i)=1;
                counter=counter+1;
            end
        end
    end
    
    sizes=[];
    for i=1:size(coords,2)
        sizes(i,1)=size(coords(i).slice,2);
    end
    
    % options=statset('MaxIter',1000);
    % GMModel=fitgmdist(sizes,3,'Options',options);
    
    % f=figure;
    % x=1;
    % f.UserData=x;
    % imshow(cat(3,phalloidenData(:,:,x),phalloidenData(:,:,x),phalloidenData(:,:,x)));
    %
    % set(f,'WindowScrollWheelFcn',{@scrollWheelChanged,phalloidenData,labeled});
    
    coordsMat=[];
    for i = 1:size(coords,2)
        if size(coords(i).slice,1)>0
            tempMat=coords(i).slice.coords;
            coordsMat=[coordsMat;tempMat,i*ones(size(tempMat,1),1)];
        end
    end
    
    realLocations=coordsMat.*voxel;
    locationsFileName=strcat(num2str(fileNum),'RLPoints.mat');
    save(locationsFileName,'realLocations');
    movefile(locationsFileName,'F:\RibbonAnalysisDataSets\RLPoints');
    %model=pcfitplane()
    
end
% function scrollWheelChanged(obj,event,phalloidenData,labeled)
% if event.VerticalScrollCount>1
%     obj.UserData=obj.UserData+1;
% elseif event.VerticalScrollCount<1
%     obj.UserData=obj.UserData-1;
% end
% x=obj.UserData;
%
% imshow(cat(3,phalloidenData(:,:,x),phalloidenData(:,:,x),phalloidenData(:,:,x)+255*uint8(labeled(:,:,x))));
% end



