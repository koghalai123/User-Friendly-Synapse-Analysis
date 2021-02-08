function [filteredData]=inputAndThreshold(threshold,medRange,data,isNucleus,range)
% 
% [filteredData]=inputAndThreshold(threshold,medRange,data,isNucleus,range)
%
% inputANdThreshold will take the input data and threshold it and do image
% enehancement to allow the computer to better recognize synapses and
% nuclei. 
% 
% filtered Data is a 3D matrix and is the result of this function and is a logical array
% containing thresholded and image enhanced data
% 
% threshold is a double containing the minimum intensity to be kept in the
% data
% medRange is the median range used for removing noise from the data
% data is the 3D matrix of input data
% isNucleus is whether this channel of the data contains nuclei. If not, a
% different type of enhancement is done
% range is the x range in which we are looking for stuff. The rest of the
% data is assumed to be logical zeros in order to speed up computing
% 
% 
% 

    %preallocation
    filteredData=zeros(size(data,1),size(data,2),size(data,3),'logical');
    
    %find mins and maxes of data for filtering. This part will need to be
    %changed for efficiency
    globalMax=max(max(max(data)));
    globalMin=min(min(min(data)));
    difference=globalMax-globalMin;
    
    %Scale data by the maxes and mins
    noThreshold=(uint16(data(range(1):range(2),:,:)-globalMin)/(difference));
    
    
    %If isNucleus, just threshold the data and do a median filter on each
    %slice
    %If ~isNucleus, it is more complicated
    if isNucleus==false
        
        for i = 1:size(data,3)
            %edge enhancement
                h=fspecial('sobel');
                f=imfilter(noThreshold(:,:,i),h);
                %median filter
                F=medfilt2(f,medRange);
                %thresholding
                filteredData(range(1):range(2),:,i)=(F>threshold);
                %another median filter
                %filteredData(:,:,i)=gpuArray.medfilt2(G,medRange);
        end
        
    else
        
        almostFilteredData=noThreshold>threshold;
        for i = 1:size(data,3)
            
            filteredData(range(1):range(2),:,i)=medfilt2(almostFilteredData(:,:,i),medRange);
        end
        
    end
    
end