IDSNamePre=strcat('5Redone','.xls');
[InumPre,ItxtPre,IrawPre]=xlsread(IDSNamePre); 
scatter3(InumPre(:,1),InumPre(:,2),InumPre(:,3));
axis(equal);