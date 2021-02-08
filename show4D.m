f5=figure();
for i=1:size(allData,3)
%     red=rescale(allData(:,:,i,1)+allData(:,:,i,4));
%     blue=rescale(allData(:,:,i,2));
%     green=rescale(allData(:,:,i,3)+allData(:,:,i,4));
%     colorMat=cat(3,red,blue,green);
    colorMat=allData(:,:,i,2);
    imshow(colorMat,[0,65535]);
    pause(.5);
end
