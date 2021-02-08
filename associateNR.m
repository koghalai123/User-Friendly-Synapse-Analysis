function [n,all]=associateNR(app,ribbon,newCenters,mu,voxel,UIAxes,ribbonRad)


% [n,all]=associateNR(app,ribbon,newCenters,mu,voxel,UIAxes,ribbonRad)
%   associate NR takes out nuclei and their associated ribbons based on an
%   overlap in the x. this allows us to be more confident in our
%   associations between nuclei and ribbons
%   n is surf objects of the nuclei
%   all is a structure of surf objects of the ribbons
% 
%   app is the GUI
%   ribbon is a structure containing ribbons grouped by a clustering
%   algorithm
%   newCenters is the matrix of centers of the nuclei that I found
%   mu is the matrix of radii of the nuclei that I found
%   voxel is the dimensions of the voxel as a matrix
%   UIAxes is that uiaxes that the associated nuclei and ribbons will be
%   graphed on
%   ribbonRad is the manual input ribbon size to allow the user to graph
%   ribbons at the size they like



mu2=mu;



ribbonClusters=struct([]);
ribbonClusters2=struct([]);
all=struct([]);

forScale=voxel;

UIAxes.cla;

hold(UIAxes,'on');
[x,y,z]=sphere;
n=gobjects;


for b =1:2
    newCenters2=[];
    newCenters2=newCenters./voxel;
    mu2=mu./voxel;
    %Find average XYZ data for each ribbon
    for i =1:size(ribbon(b).grouped,2)
        ribbonClusters(b).average(i,1:4)=[mean(ribbon(b).grouped(i).grouped(:,1:3),1),(max(ribbon(b).grouped(i).grouped(:,3))-min(ribbon(b).grouped(i).grouped(:,3)))/2];
        
    end
    for j = 1:size(newCenters2,1)
        %Find which ribbons are outside the x bounds of a nucleus
        B=single(ribbonClusters(b).average(:,1)>newCenters2(j,1)-mu2(j)) .* single(ribbonClusters(b).average(:,1)<newCenters2(j,1)+mu2(j));
        %Make a cluster containing the nuclei and its associated ribbons
        C=ribbonClusters(b).average(B==1,:);
        ribbonClusters2(b).grouped(j).grouped=C;
        
    end
    % Find actual X distances between nuclei
    distanceX=zeros(size(newCenters2,1),size(newCenters2,1));
    for i = 1:size(newCenters2,1)
        distanceX(i,1:i)=abs(newCenters2(1:i,1)-newCenters2(i,1));

    end
    %This needs to be changed. It is removing the nuclei which are within
    %130 pixels of other nuclei. This only works for the first dataset I
    %used
    A=single(distanceX<(6.4*app.voxel(1))) .* single(distanceX ~= 0);
    [row,col]=find(A==1);
    toDeleteUnique=unique([row;col]);
    %delete nuclei data
    newCenters2(toDeleteUnique,:)=[];
    mu2(toDeleteUnique,:)=[];
    %only keep the ribbon data for nuclei which correspond to the nuclei
    %that dont overlap with others
    for i = size(toDeleteUnique,1):-1:1
        ribbonClusters2(b).grouped(toDeleteUnique(i)).grouped=[];
    end



    counter=1;
    %Graph the associated ribbons for the corresponding nuclei
    for num = 1:size(newCenters,1)
        temp=gobjects;
        for i = 1:size(ribbonClusters2(b).grouped(num).grouped,1)
            
            temp(i,1)=surf(UIAxes,forScale(1)*(ribbonRad*x+ribbonClusters2(b).grouped(num).grouped(i,1)),forScale(2)*(ribbonRad*y+ribbonClusters2(b).grouped(num).grouped(i,2)),forScale(3)*(ribbonClusters2(b).grouped(num).grouped(i,4)*z+ribbonClusters2(b).grouped(num).grouped(i,3)),'UserData',[forScale(1)*ribbonClusters2(b).grouped(num).grouped(i,1),forScale(2)*ribbonClusters2(b).grouped(num).grouped(i,2),forScale(3)*ribbonClusters2(b).grouped(num).grouped(i,3)],'FaceColor',[0,b-1,2-b],'EdgeAlpha',0);
           
        end
        if size(ribbonClusters2(b).grouped(num).grouped,1)>0
            all(b).associated(counter).gobject=temp;
            counter=counter+1;
        end
        
    end

end
%Graph the nuclei
for num = 1:size(newCenters2,1)
    n(num,1)=surf(UIAxes,forScale(1)*(mu2(num,1)*x+newCenters2(num,1)),forScale(2)*(mu2(num,2)*y+newCenters2(num,2)),forScale(3)*(mu2(num,3)*z+newCenters2(num,3)),'UserData',[forScale(1)*newCenters2(num,1),forScale(2)*newCenters2(num,2),forScale(3)*newCenters2(num,3),mu2(num,:)],'FaceColor','c');
    
end
%Add legend
legend(UIAxes,[all(1).associated(1,1).gobject(1,1),all(2).associated(1,1).gobject(1,1),n(1,1)],{'Presynaptic','Postsynaptic','Nuclei'});


hold(UIAxes,'off');
axis(UIAxes,'equal');
view(UIAxes,3);
end