dataFile='IB09MidControlLeft2.czi';

%When run, loading in the files will take ~4 mins. After loading it in
%once, you can comment out the line where 'initialize' is called and it
%will run instantly. 

%The first 4 graphs are grayscale images of the nucleus, presynaptic
%ribbons, postsynaptic densities, and support cells(I think). We only need
%to worry about the first 3, but I graphed the last one anyway. The image
%updates every second, which you can change if you want to go through at a
%different speed. I would watch it 3 times. One for the nuclei, one for
%either the presynaptic or postsynaptic, and one for the 5th graph, which
%is a color image commbining the three graphs that we care about. If the
%windows are too small, just comment out everything you dont want to see
%and get rid of the subplots. Hopefully, this will let you see the data we
%are looking at




%add bfmatlab to path before running
% [voxel,dimensions,minMax,allData]=initialize(dataFile,1,2,3,4);




H=figure('units','normalized','outerposition',[0 0 1 1]);
%Go through all slices
for i=1:size(allData,3)
    
    %nucleus(first channel)
    subplot(2,4,1);
    imshow(allData(:,:,i,1),[]);
    %presynaptic ribbon(second channel)
    subplot(2,4,2);
    imshow(allData(:,:,i,2),'DisplayRange',[0,65535]);
    
    %postsynaptic density(third channel)
    subplot(2,4,3);
    imshow(allData(:,:,i,3),'DisplayRange',[0,65535]);
    
    %support cells(fourth channel)
    subplot(2,4,4);
    imshow(allData(:,:,i,4),'DisplayRange',[0,65535]);
    
    %color image combining the three we care about
    subplot(2,4,5)
    Blue=allData(:,:,i,1)/65535;
    Green=allData(:,:,i,2)/65535;
    Red=allData(:,:,i,3)/65535;
    color=cat(3,Red,Green,Blue);
    imshow(color,'DisplayRange',[0,1]);
    pause(.25);
end

