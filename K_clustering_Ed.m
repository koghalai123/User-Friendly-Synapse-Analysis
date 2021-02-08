%% K clustering to improve threshholding
%% edwin load nucleus and presynpatic ribbons
kevin_nuc_x =readtable('5Nuc_k.xlsx', 'Sheet',1, 'Range','A2:A14') ;
kevin_nuc_y =readtable('5Nuc_k.xlsx', 'Sheet',1, 'Range','B2:B14') ;
kevin_nuc_z =readtable('5Nuc_k.xlsx', 'Sheet',1, 'Range','C2:C14') ;

nucx=table2array(kevin_nuc_x);
nucy=table2array(kevin_nuc_y);
nucz=table2array(kevin_nuc_z);

nucx=sort(nucx);
nucy=sort(nucy);
nucz=sort(nucz);

kevin_nuc_x =readtable('5Pre_k.xlsx', 'Sheet',1, 'Range','A2:A204') ;
kevin_nuc_y =readtable('5Pre_k.xlsx', 'Sheet',1, 'Range','B2:B204') ;
kevin_nuc_z =readtable('5Pre_k.xlsx', 'Sheet',1, 'Range','C2:C204') ;

kevin_nuc_h =readtable('5Pre_k.xlsx', 'Sheet',1, 'Range','D2:D204') ;
kh=table2array(kevin_nuc_h);% the size/radius of each ribbon

kx=table2array(kevin_nuc_x);
ky=table2array(kevin_nuc_y);
kz=table2array(kevin_nuc_z);
%%
nuclei = [nucx nucy nucz];
pre = [kx ky kz];

figure(1);
scatter3(nuclei(:,1),nuclei(:,2),nuclei(:,3))
hold on
scatter3(pre(:,1),pre(:,2),pre(:,3),kh)
hold off
zlim([-20 40])
xlabel('x')
ylabel('y')
zlabel('z')
%% k cluster
%use kmeans clustering, setting the number of regions = to the number of
%found nuclei (number of rows in nuclei)
%[row, col] = size(nuclei);
X = pre(:,1:3);

opts = statset('Display','final');
[idx,C] = kmeans(X,length(nucx),'Distance','cityblock',...
'Replicates',5,'Options',opts);

%% plot
figure (2);
for i=1:length(nucx)
scatter3(X(idx==i,1),X(idx==i,2),X(idx==i,3))
hold on
end
legend
plot3(C(:,1),C(:,2),C(:,3),'kx',...
'MarkerSize',15,'LineWidth',3,'DisplayName','centroids') 
scatter3(nuclei(:,1),nuclei(:,2),nuclei(:,3),'DisplayName','nucleus','MarkerEdgeColor','k')
zlim([-20 40])
title 'Cluster Assignments and Centroids'
hold off
