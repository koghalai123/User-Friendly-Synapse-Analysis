function [allData] = splitToMatrices(data,nuclei,presynaptic,postsynaptic,extra)
% 
% [allData] = splitToMatrices(data,nuclei,presynaptic,postsynaptic,extra)
%
%   splitToMatrices takes the data, which is originally stored as a single
%   cell array and converts it into a single 4D array for better
%   readibility and accessibility
% 
%   allData is a 4D matrix containing the data from the actual data file.
%   The format is (x,y,z,channel)
%   nuclei is the nuclei channel
%   presynaptic is the presynaptic channel
%   postsynaptic is the postsynaptic channel
%   extra is the last channel
%


offset=[nuclei,presynaptic,postsynaptic,extra];


allData=zeros(size(data{1,1}{1,1},1),size(data{1,1}{1,1},2),round(size(data{1,1},1)/4),4,'uint16');

%Separate data into an array with the 4th dimension as channels, and the
%3rd as slice #. 
for b =1:4
    series_planes = data{1,1}(offset(b):4:size(data{1,1},1),1);
    series_planes = cat(3, series_planes{:});
    allData(:,:,:,b)=series_planes;
end




end

