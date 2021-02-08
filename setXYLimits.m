%function to set limits for hte data to get rid of useless nuclei and
%stufgf

function [f,objHandles]=setXYLimits(newCenters,mu,ribbon,dimensions,voxel,f,isInit)



if ~exist('f','var')
    f=figure();
end


a=axes(f,'OuterPosition',[.3,0,.7,1]);


if ~isInit
    locations=struct([]);
    for c=1:2

        [locations(c).mean]=findSynapseLocationsFromStruct(ribbon(c).grouped);
    end
    
    

    nuc=scatter3(a,newCenters(:,1)/voxel(1),newCenters(:,2)/voxel(2),newCenters(:,3)/voxel(3),mu,'b');
    hold(a,'on');
    pre=scatter3(a,locations(1).mean(:,1),locations(1).mean(:,2),locations(1).mean(:,3),'g');
    post=scatter3(a,locations(2).mean(:,1),locations(2).mean(:,2),locations(2).mean(:,3),'y');
    organLegend=legend(a,[nuc,pre,post],{'Nuclei','Presynaptic','Postsynaptic'});
    set(organLegend,'AutoUpdate','off')
    
    minYTemp=1;
    maxYTemp=dimensions(2);
    minZTemp=1;
    maxZTemp=dimensions(3);
else
    minYTemp=1;
    maxYTemp=2;
    minZTemp=1;
    maxZTemp=2;
    locations=[];
end



line1Nuc=line(a,[1,dimensions(1)],[minYTemp,minYTemp],[minZTemp,minZTemp]);
line2Nuc=line(a,[1,dimensions(1)],[maxYTemp,maxYTemp],[minZTemp,minZTemp]);
line3Nuc=line(a,[1,dimensions(1)],[minYTemp,minYTemp],[maxZTemp,maxZTemp]);
line4Nuc=line(a,[1,dimensions(1)],[maxYTemp,maxYTemp],[maxZTemp,maxZTemp]);

minNucYBut=uicontrol(f,'Style','slider','Min',1,'Max',dimensions(2),'Value',1,'Position',[0,0,200,20]);
maxNucYBut=uicontrol(f,'Style','slider','Min',1,'Max',dimensions(2),'Value',dimensions(2),'Position',[0,20,200,20]);
minNucZBut=uicontrol(f,'Style','slider','Min',1,'Max',dimensions(3),'Value',1,'Position',[0,40,200,20]);
maxNucZBut=uicontrol(f,'Style','slider','Min',1,'Max',dimensions(3),'Value',dimensions(3),'Position',[0,60,200,20]);
set(minNucYBut,'CallBack',{@plotLines,line1Nuc,line2Nuc,line3Nuc,line4Nuc,minNucYBut,maxNucYBut,minNucZBut,maxNucZBut,dimensions});
set(maxNucYBut,'CallBack',{@plotLines,line1Nuc,line2Nuc,line3Nuc,line4Nuc,minNucYBut,maxNucYBut,minNucZBut,maxNucZBut,dimensions});
set(minNucZBut,'CallBack',{@plotLines,line1Nuc,line2Nuc,line3Nuc,line4Nuc,minNucYBut,maxNucYBut,minNucZBut,maxNucZBut,dimensions});
set(maxNucZBut,'CallBack',{@plotLines,line1Nuc,line2Nuc,line3Nuc,line4Nuc,minNucYBut,maxNucYBut,minNucZBut,maxNucZBut,dimensions});


line1Rib=line(a,[1,dimensions(1)],[minYTemp,minYTemp],[minZTemp,minZTemp],'Color',[1,0,0]);
line2Rib=line(a,[1,dimensions(1)],[maxYTemp,maxYTemp],[minZTemp,minZTemp],'Color',[1,0,0]);
line3Rib=line(a,[1,dimensions(1)],[minYTemp,minYTemp],[maxZTemp,maxZTemp],'Color',[1,0,0]);
line4Rib=line(a,[1,dimensions(1)],[maxYTemp,maxYTemp],[maxZTemp,maxZTemp],'Color',[1,0,0]);

minRibYBut=uicontrol(f,'Style','slider','Min',1,'Max',dimensions(2),'Value',1,'Position',[0,100,200,20]);
maxRibYBut=uicontrol(f,'Style','slider','Min',1,'Max',dimensions(2),'Value',dimensions(2),'Position',[0,120,200,20]);
minRibZBut=uicontrol(f,'Style','slider','Min',1,'Max',dimensions(3),'Value',1,'Position',[0,140,200,20]);
maxRibZBut=uicontrol(f,'Style','slider','Min',1,'Max',dimensions(3),'Value',dimensions(3),'Position',[0,160,200,20]);
set(minRibYBut,'CallBack',{@plotLines,line1Rib,line2Rib,line3Rib,line4Rib,minRibYBut,maxRibYBut,minRibZBut,maxRibZBut,dimensions});
set(maxRibYBut,'CallBack',{@plotLines,line1Rib,line2Rib,line3Rib,line4Rib,minRibYBut,maxRibYBut,minRibZBut,maxRibZBut,dimensions});
set(minRibZBut,'CallBack',{@plotLines,line1Rib,line2Rib,line3Rib,line4Rib,minRibYBut,maxRibYBut,minRibZBut,maxRibZBut,dimensions});
set(maxRibZBut,'CallBack',{@plotLines,line1Rib,line2Rib,line3Rib,line4Rib,minRibYBut,maxRibYBut,minRibZBut,maxRibZBut,dimensions});


limitXYBut=uicontrol(f,'Style','pushbutton','String','Use Limits','Position',[10,240,100,30],'Callback',{@limitXYForOrg,f,ribbon,locations,newCenters,mu,line1Rib,line4Rib,line1Nuc,line4Nuc,voxel});

objHandles=[line1Nuc,line2Nuc,line3Nuc,line4Nuc;line1Rib,line2Rib,line3Rib,line4Rib];


function plotLines(~,~,line1,line2,line3,line4,minYBut,maxYBut,minZBut,maxZBut,dimensions)
minY=minYBut.Value;
maxY=maxYBut.Value;
minZ=minZBut.Value;
maxZ=maxZBut.Value;


line1.YData=[minY,minY];
line1.ZData=[minZ,minZ];
line1.XData=[1,dimensions(1)];

line2.YData=[maxY,maxY];
line2.ZData=[minZ,minZ];
line2.XData=[1,dimensions(1)];


line3.YData=[minY,minY];
line3.ZData=[maxZ,maxZ];
line3.XData=[1,dimensions(1)];

line4.YData=[maxY,maxY];
line4.ZData=[maxZ,maxZ];
line4.XData=[1,dimensions(1)];


end

function limitXYForOrg(~,~,f,ribbon,locations,newCenters,mu,line1Rib,line4Rib,line1Nuc,line4Nuc,voxel)
nucY=[line1Nuc.YData(1,1)*voxel(2),line4Nuc.YData(1,1)*voxel(2)];
nucZ=[line1Nuc.ZData(1,1)*voxel(3),line4Nuc.ZData(1,1)*voxel(3)];

ribY=[line1Rib.YData(1,1),line4Rib.YData(1,1)];
ribZ=[line1Rib.ZData(1,1),line4Rib.ZData(1,1)];

orgData=struct([]);

for b =1:2
    validRibInd=locations(b).mean(:,2)>ribY(1) & locations(b).mean(:,2)<ribY(2) & locations(b).mean(:,3)>ribZ(1)  & locations(b).mean(:,3)<ribZ(2);
    counter=1;
    for i =1:size(validRibInd,1)
        if validRibInd(i)==1
            orgData(b).Ribbon(counter).grouped=ribbon(b).grouped(i).grouped;
            counter=counter+1;
%         else
%             orgData(b).Ribbon(counter).grouped=[];
%             counter=counter+1;

        end
    end
    
end
for b =1:2
    if size(orgData(b).Ribbon,2)==0
        orgData(b).Ribbon(1).grouped=[0,0,0,1];
    end
end
validNucInd=newCenters(:,2)>nucY(1) & newCenters(:,2)<nucY(2) & newCenters(:,3)>nucZ(1) & newCenters(:,3)<nucZ(2);
validNuc=newCenters(validNucInd,:);
validMu=mu(validNucInd,:);

orgData(1).Nucleus=[validNuc,validMu];
orgData(1).NucLimits=[line1Nuc.YData(1,1),line4Nuc.YData(1,1);line1Nuc.ZData(1,1),line4Nuc.ZData(1,1)];
orgData(1).RibLimits=[ribY;ribZ];

f.UserData=orgData;
f.Name=strcat('Presynaptic: ',num2str(size(orgData(1).Ribbon,2)),' Postsynaptic: ',num2str(size(orgData(2).Ribbon,2)),' Nuclei:', num2str(size(orgData(1).Nucleus,1)),' Pre/Nuc:',num2str(size(orgData(1).Ribbon,2)/size(orgData(1).Nucleus,1)), ' Post/Nuc:',num2str(size(orgData(2).Ribbon,2)/size(orgData(1).Nucleus,1)));
f.NumberTitle='off';
end





end