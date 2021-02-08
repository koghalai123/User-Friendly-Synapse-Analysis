function [ribbons]=ribbonStuff(scaledData,epsilon,minGroup,range,startValue,stopValue)
% 
% [ribbons]=ribbonStuff(scaledData,epsilon,minGroup,range,startValue,stopValue,xMin,xMax)
%
%   ribbonStuff goes through each slice and looks for places where a ribbon
%   might be based on their intensity and size.
%
%   ribbons is a structure containing the places where there is a high
%   enough intensity and size to be likely part of a ribbon
% 
%   scaledData is the filtered data
%   epsilon is the search range for the ribbons. I other words, how far
%   apart ribbons need to be to be considered separate
%   minGroup is hte minimum pixel size of each rbbon instance
%   range is the range in which ribbons are being looked for
%   startValue is the lowest slice that the user is interested in
%   stopValue is the highest slice that the user is interested in
%   xMin is the minimum Y that the user is interested in
%   xMax is the maximum Y that the user is interested in 
% 
xMin=range(1);
xMax=range(2);
for j = startValue:size(scaledData,3)-stopValue
        %find points in the data
        [col,row]=find(scaledData(xMin:xMax,:,j)==1);
        %do a density based cluster on the points in the data to find where
        %the ribbons are on this slice
        if size(row,1)>0
            idx=dbscan([row,col],epsilon,minGroup);
            average=zeros(max(idx),2,'single');
            %remove points that dont fit the clusters
            for i =1:max(idx)
                inGroup=find(idx==i);
                theGroup=[row(inGroup),col(inGroup)];
                average(i,:)=[median(theGroup(:,1)),median(theGroup(:,2))];
            end
            centers=average;
            %remove those outside acceptable y range
            
%             if size(centers,1)>0
%                 L=single(centers(:,2)<range(2)) .* single(centers(:,2)>range(1));
%                 centers=[nonzeros(L.*centers(:,1)),nonzeros(L.*centers(:,2))];
%             end

            
%             %Add centers and radius to structure for storage 
            storeCenters2(j).centers=[centers(:,1),centers(:,2)+xMin-1,ones(size(centers,1),1)*j];
        end
end
if exist('storeCenters2', 'var')
    ribbons=vertcat(storeCenters2(:).centers);
else
    ribbons=[];
end

   
  end
    