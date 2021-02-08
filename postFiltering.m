function rmBig=postFiltering(dimensions,allData,postChannel,settings)

%post is [5,5,3] and thresh of 3

%This is what is done, I just turned it into 1 line to save memory
%rescaled=rescale(allData(:,:,:,postChannel));
%brightAdj=changeBrightness(.4,rescaled);
%contrastAdj=changeContrast(.33,brightAdj);
%filtered=medfilt3(contrastAdj,settings(1:3));


brightAndContrastAdj=changeContrast(.38,changeBrightness(.4,(allData(:,:,:,postChannel))));
filtered=medfilt3(brightAndContrastAdj,settings(1:3));
% slice=50;
% edges=edge(filtered(:,:,slice));
% sharp=imsharpen(filtered(:,:,50));
%adap=adaptthresh(filtered);
% localFiltered=medfilt3(contrastAdj,[19,19,7]);





scaleFactor=4;
% reducedRes=zeros(round(dimensions(1)/scaleFactor),round(dimensions(2)/scaleFactor),dimensions(3));
% backToNormal=zeros(dimensions(1),dimensions(2),dimensions(3));
sz=round([dimensions(1:2)/scaleFactor,dimensions(3)]);

backToNormal=imresize3(medfilt3(imresize3(filtered,sz),[7,7,1]),dimensions);

% for i =1:dimensions(3)
%     reducedRes(:,:,i)=medfilt2(imresize(filtered(:,:,i),sz),[7,7]);
%     
%     backToNormal(:,:,i)=imresize(reducedRes(:,:,i),dimensions(1:2));
% end
rmBig=filtered-backToNormal;

end
% brightAdj2=changeBrightness(.2,filtered);
% contrastAdj2=changeContrast(.33,filtered);