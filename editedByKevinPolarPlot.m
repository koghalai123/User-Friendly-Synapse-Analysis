%% rotate segmented single nucleus and its respective ribbons to be perpindicular to xy plane
% rotation of unique axis
%% decide which datset to load
num = 'What dataset do you want to look at?'; 
dataset = input(num);
%% load data  nucleus kevins

KDSNameNuc=strcat(num2str(dataset),'Nuc.xlsx');
KDSNamePre=strcat(num2str(dataset),'Pre.xlsx');
KDSNamePost=strcat(num2str(dataset),'Post.xlsx');

IDSNamePre=strcat(num2str(dataset),'.xls');

[numNuc,txtNuc,rawNuc] = xlsread(KDSNameNuc); 
[numPre,txtpre,rawPre] = xlsread(KDSNamePre); 
[numPost,txtPost,rawPost] = xlsread(KDSNamePost); 

[InumPre,ItxtPre,IrawPre]=xlsread(IDSNamePre); 

nucx=numNuc(:,1);
nucy=numNuc(:,2);
nucz=numNuc(:,3);


nucx=sort(nucx);
nucy=sort(nucy);
nucz=sort(nucz);

% switch dataset
%     case 5
% kevin_nuc_x =readtable('5Nuc_k.xlsx', 'Sheet',1, 'Range','A2:A14') ;
% kevin_nuc_y =readtable('5Nuc_k.xlsx', 'Sheet',1, 'Range','B2:B14') ;
% kevin_nuc_z =readtable('5Nuc_k.xlsx', 'Sheet',1, 'Range','C2:C14') ;
%     case 4
% kevin_nuc_x =readtable('4Nuc_k.xlsx', 'Sheet',1, 'Range','A2:A18') ;
% kevin_nuc_y =readtable('4Nuc_k.xlsx', 'Sheet',1, 'Range','B2:B18') ;
% kevin_nuc_z =readtable('4Nuc_k.xlsx', 'Sheet',1, 'Range','C2:C18') ;
%     case 3
% kevin_nuc_x =readtable('3Nuc_k.xlsx', 'Sheet',1, 'Range','A2:A13') ;
% kevin_nuc_y =readtable('3Nuc_k.xlsx', 'Sheet',1, 'Range','B2:B13') ;
% kevin_nuc_z =readtable('3Nuc_k.xlsx', 'Sheet',1, 'Range','C2:C13') ;
%         
% end

% nucx=table2array(kevin_nuc_x);
% nucy=table2array(kevin_nuc_y);
% nucz=table2array(kevin_nuc_z);

%% load data presynaptic ribbons
% switch dataset
%     case 5
%         kevin_nuc_x =readtable('5Pre_k.xlsx', 'Sheet',1, 'Range','A2:A204') ;
%         kevin_nuc_y =readtable('5Pre_k.xlsx', 'Sheet',1, 'Range','B2:B204') ;
%         kevin_nuc_z =readtable('5Pre_k.xlsx', 'Sheet',1, 'Range','C2:C204') ;
% 
%         ido_nuc_x =readtable('5Pre_ido.xls', 'Sheet',1, 'Range','A3:A222') ;
%         ido_nuc_y =readtable('5Pre_ido.xls', 'Sheet',1, 'Range','B3:B222') ;
%         ido_nuc_z =readtable('5Pre_ido.xls', 'Sheet',1, 'Range','C3:C222') ;
%     case 4
%          kevin_nuc_x =readtable('4Pre_k.xlsx', 'Sheet',1, 'Range','A2:A309') ;
%          kevin_nuc_y =readtable('4Pre_k.xlsx', 'Sheet',1, 'Range','B2:B309') ;
%          kevin_nuc_z =readtable('4Pre_k.xlsx', 'Sheet',1, 'Range','C2:C309') ;
% 
%          ido_nuc_x =readtable('4Pre_ido.xls', 'Sheet',1, 'Range','A3:A304') ;
%          ido_nuc_y =readtable('4Pre_ido.xls', 'Sheet',1, 'Range','B3:B304') ;
%          ido_nuc_z =readtable('4Pre_ido.xls', 'Sheet',1, 'Range','C3:C304') ;
%     case 3
%          kevin_nuc_x =readtable('3Pre_k.xlsx', 'Sheet',1, 'Range','A2:A193') ;
%          kevin_nuc_y =readtable('3Pre_k.xlsx', 'Sheet',1, 'Range','B2:B193') ;
%          kevin_nuc_z =readtable('3Pre_k.xlsx', 'Sheet',1, 'Range','C2:C193') ;
% 
%          ido_nuc_x =readtable('3Pre_ido.xls', 'Sheet',1, 'Range','A3:A231') ;
%          ido_nuc_y =readtable('3Pre_ido.xls', 'Sheet',1, 'Range','B3:B231') ;
%          ido_nuc_z =readtable('3Pre_ido.xls', 'Sheet',1, 'Range','C3:C231') ;
% end





kx=numPre(:,1);
ky=numPre(:,2);
kz=numPre(:,3);

ix=InumPre(:,1);
iy=InumPre(:,2);
iz=InumPre(:,3);

% kx=table2array(kevin_nuc_x);
% ky=table2array(kevin_nuc_y);
% kz=table2array(kevin_nuc_z);
% 
% ix=table2array(ido_nuc_x);
% iy=table2array(ido_nuc_y);
% iz=table2array(ido_nuc_z);
%% segment ribbons to their nucleus
%create struct to partition presynaptic ribbons to groups belonging to a nucleus
for t=1:2 % repeat code for ido and kevin data
   
      if t==2 % to switch to  idos data and reduce repetive code lines
        keven=[kx ky kz]; % save kevins data
        kx=ix;
        ky=iy;
        kz=iz;
      end
KX=struct([]);
KY=struct([]);
KZ=struct([]);
thresh=[];
a=sort(nucx); % rearrange from least to greatest top to bottom
for i=1:length(nucx)-1
thresh(i)=(a(i+1)+a(i))/2;
end
thresh=[0 thresh];

for k=1:length(thresh)-1
    kx1=[];
    ky1=[];
    kz1=[];
    
    kx2=[];
    ky2=[];
    kz2=[];
for j=1:length(kx)
    if kx(j)<thresh(k+1)&& kx(j)>thresh(k)
        tempx=kx(j);
        tempy=ky(j);
        tempz=kz(j);
        kx1=[kx1 tempx];
        ky1=[ky1 tempy];
        kz1=[kz1 tempz];
    elseif kx(j)>max(thresh)
        tempx=kx(j);
        tempy=ky(j);
        tempz=kz(j);
        kx2=[kx2 tempx];
        ky2=[ky2 tempy];
        kz2=[kz2 tempz];
    end
    end
    KX{k}=kx1;
    KY{k}=ky1;
    KZ{k}=kz1;
end
 KX{k+1}=kx2;
 KY{k+1}=ky2;
 KZ{k+1}=kz2;
 %% find centroid of all clusters
 for i=1:length(KX)
 avgKX(i)=mean(KX{i});
 avgKY(i)=mean(KY{i});
 avgKZ(i)=mean(KZ{i});
 end
%% plot segmented presynaptic nucleus to its respecitve nucleus
if t==1 % to avoid repetiveness while I run ido data
num = 'how many nucleus do you want plotted? ';
number = input(num);
end
figure (1)
for i=1:number
       switch t
           case 1
               prompt = 'What nucleus do you want to isolate in Kevin? ';
           case 2
               prompt = 'What nucleus do you want to isolate in Ido? ';
       end
nuc = input(prompt);
switch t
    case 1
        scatter3(KX{nuc},KY{nuc},KZ{nuc},'ro')
        hold on
        scatter3(nucx(nuc),nucy(nuc),nucz(nuc),'ko')
        scatter3(avgKX(nuc),avgKY(nuc),avgKZ(nuc),'k*') % centroid of specifc ribbon cluster
    case 2
        hold on
          scatter3(nucx(nuc),nucy(nuc),nucz(nuc),'ko')
          scatter3(avgKX(nuc),avgKY(nuc),avgKZ(nuc),'k*')
          if i==max(number)
              legend('Kevin','Nucleus','Centroid')
              legend('boxoff')
          end
          scatter3(KX{nuc},KY{nuc},KZ{nuc},'DisplayName','Ido','MarkerEdgeColor','b') % ido data
end
end
hold off
%xlim([-100,100])
%ylim([-100,100])
zlim([-20,40])
xlabel('x')
ylabel('y')
zlabel('z')
%% transition centroid and its nucleus to center (0,0)
if number==1
    figure (2)
    transKX=avgKX(nuc)-nucx(nuc);
      transKY=avgKY(nuc)-nucy(nuc);
      transKZ=avgKZ(nuc)-nucz(nuc);
      switch t
          case 1
        scatter3(transKX,transKY,transKZ,'r*')
        hold on
        scatter3(0,0,0,'ko')
        xlabel('x')
        ylabel('y')
        zlabel('z')
        xlim([-20,20])
        ylim([-20,20])
        zlim([-20,20])
          case 2
              hold on
              scatter3(transKX,transKY,transKZ,'b*')
              legend('kevin','nucleus','Ido')
      end
      hold off
end
 %% First dot product angle between two lines to find two angles for rotation
% goal is to average the single cluster to find centroid of cluster and
% make the vector of this centroid-nucleus line parallel with z-axis perp. to xzplane
if number==1
a=[transKX 0 transKZ ];% centroid XZ vector projection
b=[0 0 1];% z-axis
XZangle=acosd(dot(a,b)/(norm(a)*norm(b)));

%error code below since XZ rotation makes YZ angle ~= starting position after
%first rotation so need to do dot product after first rotation to figure out
%correct angle.
%{ 
a=[0 transKY transKZ ];% centroid YZ vector projections
YZangle=acosd(dot(a,b)/(norm(a)*norm(b)));
%}
%% rotate centroid about y-axis

%Around Y-axis: 
theta=(XZangle); % degree only
X = transKX*cosd(theta) + transKZ*sind(theta);
Y = transKY;
Z = transKZ*cosd(theta) -transKX*sind(theta);
%% second angle dot product
a=[0 Y Z ];% centroid YZ vector projections
YZangle=acosd(dot(a,b)/(norm(a)*norm(b)));
%% rotate centroid about x -axis
%Around X-axis: 
temp=[X; Y ;Z];
theta=(YZangle);% degree
X = temp(1,:);
Y =temp(2,:)*cosd(theta) - temp(3,:)*sind(theta);
Z = temp(2,:)*sind(theta) + temp(3,:)*cosd(theta);
end
%% plot to verify that centroid vector is parallel to z axis
if number==1
    figure (3)
    switch t
        case 1
            scatter3(X,Y,Z,'r*')
            cx=X+nucx(nuc); % save new centroid coord. and transition back
            cy=Y+nucy(nuc);
            cz=Z+nucx(nuc);
            hold on
        
            scatter3(0,0,0,'ko')
            xlabel('x')
            ylabel('y')
            zlabel('z')
            xlim([-20,20])
            ylim([-20,20])
            zlim([-20,20])
        case 2
            hold on
            scatter3(X,Y,Z,'b*')
            legend('kevin','nucleus','Ido')
    end  
    hold off
end
%% plot desired segmented correctly oriented cluster and nucleus polarplot
%% transition desired cluster to center around desired nucleus
if number==1
    transKX=KX{nuc}-nucx(nuc);
      transKY=KY{nuc}-nucy(nuc);
      transKZ=KZ{nuc}-nucz(nuc);
%%
%Around Y-axis: 
theta=(XZangle); % degree only

X = transKX*cosd(theta) + transKZ*sind(theta);
Y = transKY;
Z = transKZ*cosd(theta) -transKX*sind(theta);

temp=[X; Y ;Z];
%Around X-axis:
theta=(YZangle); % degree only
X = temp(1,:);
Y =temp(2,:)*cosd(theta) - temp(3,:)*sind(theta);
Z = temp(2,:)*sind(theta) + temp(3,:)*cosd(theta);
%% transition cluster back to original position
 X=X+nucx(nuc);
 Y=Y+nucy(nuc);
 Z=Z+nucz(nuc);
%% final plot verification and final polarplot of nucleus and ribbon of interest
figure(4)
switch t
    case 1
        scatter3(X,Y,Z,'ro')
        hold on
        scatter3(nucx(nuc),nucy(nuc),nucz(nuc),'ko')
        scatter3(avgKX(nuc),avgKY(nuc),avgKZ(nuc),'k*') % centroid of specifc ribbon cluster
        scatter3(cx,cy,cz,'k*') % new location of centroid of specifc ribbon cluster
        zlim([-20,40])
        xlabel('x(um)')
        ylabel('y(um)')
        zlabel('z(um)')
    case 2
        hold on
        legend('kevin','Nucleus','centroid')
        scatter3(X,Y,Z,'DisplayName','Ido','MarkerEdgeColor','b')
end
hold off
r=(sqrt((X-nucx(nuc)).^2+(Y-nucy(nuc)).^2))'; % center ribbons to nucleus
phi=(atand((Y-nucy(nuc))./(X-nucx(nuc))).*(2*pi/360))';% converts to radians

for i=1:length(KX{nuc})
    if X(i)-nucx(nuc)<0
       phi(i)=phi(i)+pi;% fixes the issue of atand limited to range -90 to 90
    end
end
figure(5)
switch t
    case 1
        %polarplot(phi,r,'ro')% accepts phi as radians and converts to degrees
        mypolar(phi,r,'ro')
    case 2
        hold on
        %polarplot(phi,r,'bo')% accepts phi as radians and converts to degrees
        mypolar(phi,r,'bo')
end
hold off
title (sprintf('Dataset %d Ribbons centered around Nucleus (%1fum,%1fum)',dataset,round(nucx(nuc),1),round(nucy(nuc),1)))
legend('Kevin','Ido')
legend('boxoff')
end
end
if t==2
kx=keven(:,1); % restore kevins values
ky=keven(:,2);% restore kevins values

kz=keven(:,3);% restore kevins values
end
%% test for conservation of magnitude for each point to make sure no squeeze of data
%{
figure(8)
scatter3(KX{nuc}, KY{nuc}, KZ{nuc},'ro')
hold on

scatter3(KX{nuc}(4), KY{nuc}(4), KZ{nuc}(4),'go')
scatter3(KX{nuc}(9), KY{nuc}(9), KZ{nuc}(9),'go')
scatter3( nucx(nuc),nucy(nuc), nucz(nuc),'k')
xlabel('x')
ylabel('y')
zlabel('z')
zlim([-20,40])
ylim([78,84])


i=4
j=5
 d1 = pdist([KX{nuc}(i) KY{nuc}(i) KZ{nuc}(i);[KX{nuc}(i+j) KY{nuc}(i+j) KZ{nuc}(i+j)]],'euclidean')
     d2 = pdist([X(i) Y(i) Z(i);[X(i+j) Y(i+j) Z(i+j)]],'euclidean')
%}