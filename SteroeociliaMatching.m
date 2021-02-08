listing =dir('RLPointsManual');
addpath('RLPointsManual')
pointMat=zeros(287,36);

for i=3:size(listing,1)
    counter=0;
    tempTable=readtable(listing(i).name);
    tempMat=table2array(tempTable);
    hyphenLoc=strfind(listing(i).name,'-');
    if size(hyphenLoc,1)==0
        hyphenLoc=strfind(listing(i).name,'.');
    end
    startNum=str2num(listing(i).name(1:hyphenLoc-1));
    for j=1:(size(tempMat,1)/12)
        points=tempMat(counter+1:counter+12,2:end);
        
        sortedPoints=sortrows(points,2);
        
        reshapedTemp=[];
        for k=1:12
            reshapedTemp=[reshapedTemp,sortedPoints(k,:)];
        end
        
        pointMat(startNum+(counter/12),:)=reshapedTemp;
        counter=counter+12;
    end
    
end