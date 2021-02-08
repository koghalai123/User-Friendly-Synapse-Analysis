% dont know if it is being used, but finds the range in which t he synapses
% are

function [range]=findRibbonRange(ribbonLocs,percentile)
center=(mean(ribbonLocs));
[~,distances]=dsearchn(center(:,2),ribbonLocs(:,2));
[noOutliers,isOutlier]=rmoutliers(distances,'percentiles',[0,percentile]);
ribbonLocs((isOutlier==1),:)=[];
yMax=max(ribbonLocs(:,2)); 
yMin=min(ribbonLocs(:,2)); 
zMax=max(ribbonLocs(:,3)); 
zMin=min(ribbonLocs(:,3)); 
range=[yMin,yMax;zMin,zMax];
end