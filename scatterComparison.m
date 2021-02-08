
num = 'What dataset do you want to look at? '; 
dataset = input(num,'s');

%You may need to change suffixes to match to your own data set name
KDSNameNuc=strcat((dataset),'Nuc.xlsx');
KDSNamePre=strcat((dataset),'Pre.xlsx');
KDSNamePost=strcat((dataset),'Post.xlsx');
%You may need to change suffixes to match to Ido's data set name
IDSNamePre=strcat((dataset),'.xls');

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


kx=numPre(:,1);
ky=numPre(:,2);
kz=numPre(:,3);

ix=InumPre(:,1);
iy=InumPre(:,2);
iz=InumPre(:,3);

%plot both sets
f=figure();
a=axes(f);
hold(a,'on');
kRib=scatter3(a,kx,ky,kz,'Marker','o');
iRib=scatter3(a,ix,iy,iz,'Marker','o');
kNuc=scatter3(a,numNuc(:,1),numNuc(:,2),numNuc(:,3),'Marker','o');
hold(a,'off');
view(a,3);
axis(a,'equal');

%Find the shortest distance between each of the two data sets
[k,dist]=dsearchn([kx,ky,kz],[ix,iy,iz]);
%Remove outliers based on percentiles
noOut=rmoutliers(dist,'Percentile',[0,93]);
%find median distance
medData=median(noOut);


