function [R1,R2]=representNAndR(NAssociated,RAssociated,UIAxes)
% 
% [R1,R2]=representNAndR(NAssociated,RAssociated,UIAxes)
%
%   representNAndR graphs the nuclei and ribbons that are associated with
%   each other on top of each other. This may help us see trends in 3D in
%   response to blasts
% 
%   R1 is the presynaptic ribbons as scatter objects
%   R2 is the presynaptic ribbons as scatter objects
%
%   NAssociated is the matrix of nuclei that are associated with ribbons
%   and do not overlap in the Y
%   RAssociated is a structure of ribbons that are associated with nuclei
%   that do not overlap with other nuclei
%

allVec=struct([]);

N=scatter3(UIAxes,0,0,0,'Marker','.','CData',[0,0,0],'SizeData',5000);
for b = 1:2
    vec1=[];
    for i=1:size(NAssociated,1)
        if size(RAssociated(b).associated(i).gobject,1)>0
            for j = 1:size(RAssociated(b).associated(i).gobject,1)
                vec1=[vec1;RAssociated(b).associated(i).gobject(j,1).UserData(1,1:3)-NAssociated(i,1).UserData(1,1:3)];
            end
        else
            vec1=[];
        end
    end
    allVec(b).vec=vec1;
end
hold(UIAxes,'on');
R1=scatter3(UIAxes,allVec(1).vec(:,1),allVec(1).vec(:,2),allVec(1).vec(:,3),'Marker','.','CData',[0,0,1]);
R2=scatter3(UIAxes,allVec(2).vec(:,1),allVec(2).vec(:,2),allVec(2).vec(:,3),'Marker','.','CData',[0,1,0]);
hold(UIAxes,'off');
axis(UIAxes,'equal');

legend(UIAxes,[R1(1,1),R2(1,1),N],{'Presynaptic','Postsynaptic','Nuclei'});


end