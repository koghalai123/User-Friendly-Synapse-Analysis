

nuclei = table2array(readtable('1Nuc.xlsx'));
pre = table2array(readtable('1Pre.xlsx'));
post = table2array(readtable('1Post.xlsx'));

figure(1);
hold on

scatter3(nuclei(:,1),nuclei(:,2),nuclei(:,3),5*nuclei(:,4));
scatter3(pre(:,1),pre(:,2),pre(:,3),pre(:,4));
scatter3(post(:,1),post(:,2),post(:,3),post(:,4));

hold off

%use kmeans clustering, setting the number of regions = to the number of
%found nuclei (number of rows in nuclei)
[row, col] = size(nuclei);
X = pre(:,1:3);

[idx,C] = kmeans(X,row);

x1 = min(X(:,1)):0.01:max(X(:,1));
x2 = min(X(:,2)):0.01:max(X(:,2));
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)]; % Defines a fine grid on the plot

idx2Region = kmeans(XGrid,row,'MaxIter',1,'Start',C);

figure(2);
hold on

gscatter(XGrid(:,1),XGrid(:,2),idx2Region);
scatter3(X(:,1),X(:,2),X(:,3),'k*','MarkerSize',5);

legend('Region 1','Region 2','Region 3','Data','Location','SouthEast');
hold off;
