function [storeCenters,storeRadii]=viewPreliminaryData(nucleiData,range,sensitivity,stopValue,startValue,radius)
% 
% [storeCenters,storeRadii]=viewPreliminaryData(nucleiData,range,sensitivity,stopValue,startValue,radius,xMin,xMax)
%
%   viewPreliminaryData goes through slices of the nuclei data and looks
%   for circles.
% 
%   storeCenters is the locations and slice of each detected circle(struct)
%   storeRadii is the radii of each of the circles(struct)
% 
%   nucleiData is a 3D array(or 2D is just looking at one slice) of the
%   nuclei data after being filtered
%   range is the y range that the user is interested in
%   sensitivity is the sensitivity of the circles detection algorithm
%   stopValue is the last slice that the user is interested in
%   start Value is the first slice that the user is interested in
%   radius is a matrix containing a pixel estimate for how big the nuclei
%   are
%   xMin is the minimum y value that the user is interested in
%   xMax is the maximum y value that the user is interested in
% 
% 
% 

%sensitivty 9.883, range=[1200,1500], stopValue=88, nucleiSlice=0 THIS IS ONLY FOR THE
%TESTDATA
    xMin=range(1);
    xMax=range(2);

    storeCenters=[];
    storeRadii=[];
    %Go through each slice in the nuclei channel
    for j = startValue:size(nucleiData,3)-stopValue
        %find circles
        [centers, radii] = imfindcircles(nucleiData(xMin:xMax,:,j),radius,'Sensitivity',sensitivity);
        
       %determine if the nuclei centers are within acceptable Y range and
       %remove those which are not
%         centers2=[];
%         if size(centers,1)>0
%             L=single(centers(:,2)<range(2)) .* single(centers(:,2)>range(1));
%             centers2=[nonzeros(L.*centers(:,1)),nonzeros(L.*centers(:,2))];
%             radii=nonzeros(L.*radii);
%         end
       
        %Store the data.
        if size(centers,1)>0
            storeCenters=[storeCenters;centers(:,1),centers(:,2)+xMin,ones(size(centers,1),1)*j];
            storeRadii=[storeRadii;radii];
        end
    end
end
