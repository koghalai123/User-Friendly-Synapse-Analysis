%not being used

[~,identifier,raw] = xlsread('Copy of data_identifiers_jt1 (1).xlsx',2);


% find shared characteristics in the names
names=["Names"];
for i=2:size(raw,1)
    names(i,1)=convertCharsToStrings(raw{i, 1});
end



expStats=["Experiment Number","Treatment","Side","Location","Random Code Number"];
for j=2:size(names,1)
    
    %Experiment Number
    num=strfind(names(j,1),'IB');
    asChar=char(names(j,1));
    expStats(j,1)=string(asChar(num:num+3));
    
    %treatment
    num=strfind(names(j,1),'oise');
    num2=strfind(names(j,1),'ontrol');
    if size(num,1)>0
        expStats(j,2)="Treated";
    elseif size(num2,1)>0
        expStats(j,2)="Control";
    end
    
    %Side
    num=strfind(names(j,1),'Right');
    num2=strfind(names(j,1),'Left');
    if size(num,1)>0
        fullName=char(names(j,1));
        expStats(j,3)=string(fullName(num:end));
        
    elseif size(num2,1)>0
        fullName=char(names(j,1));
        expStats(j,3)=string(fullName(num2:end));
    end
    
    %Location
    num=strfind(names(j,1),"Apex");
    num2=strfind(names(j,1),'Mid');
    num3=strfind(names(j,1),'Base');
    if size(num,1)>0
        expStats(j,4)="Apex";
    elseif size(num2,1)>0
        expStats(j,4)="Mid";
    elseif size(num3,1)>0
        expStats(j,4)="Base";
    end
    
    expStats(j,5)=raw{j, 2};
end

dataTable=table();
[~,sheet_name]=xlsfinfo('Synapse-IHC Ratios (1).xlsx');
for k=1:5
    
    
    [~,~,temp]=xlsread('Synapse-IHC Ratios (1).xlsx',sheet_name{k});
    newTab=cell2table(temp);
    
    
    dataTable=[dataTable;newTab(:,1:3),table(repmat([k],size(newTab,1),1),'VariableNames',["temp4"]);table(NaN,NaN,NaN,NaN,'VariableNames',["temp1","temp2","temp3","temp4"]);table(NaN,NaN,NaN,NaN,'VariableNames',["temp1","temp2","temp3","temp4"])];
end


dataMat=string(table2array(dataTable(:,1)));
headerInfo=find(dataMat=='IHC')-1;

IdoExpNum(:,1)=(dataMat(headerInfo));
IdoPageNum(:,1)=table2array(dataTable(headerInfo,4));

expStats2=["Experiment Number","Treatment","Side","Location","Page Number","Value"];
counter=2;
for j=1:size(headerInfo,1)
    start=headerInfo(j);
    temp=dataTable(start:start+4,1:3);
    for k=1:2
        for l=1:3
            location=table2array(temp(2+l,1));
            side=string(table2array(temp(1,1+k)));
            value=table2array(temp(2+l,1+k));
            
            isRight=strfind(side,'Right');
            isLeft=strfind(side,'Left');
            
%             if size(isRight,1)>0
%                 expStats2(counter,3)="Right";
%             elseif size(isLeft,1)>0
%                 
% 
%             end
            expStats2(counter,3)=string(side);
            expNum=char(IdoExpNum(j));
            expStats2(counter,1)=string(expNum(1:4));
            expStats2(counter,4)=string(location);
            expStats2(counter,5)=IdoPageNum(j);
            expStats2(counter,6)=num2str(cell2mat(value));
            
            if expStats2(counter,5)=="5"
                expStats2(counter,2)="Control";
            else
                expStats2(counter,2)="Noise";
            end
            
            
            counter=counter+1;
        end
    end
    
    
end

missing=ismissing(expStats);
[row,col]=find(missing==1);
expStats(row,col)="";

missing=ismissing(expStats2);
[row,col]=find(missing==1);
expStats2(row,col)="";

% for i=2:size(expStats,1)
%     temp="";
%     for j=1:4
%         temp=append(temp,expStats(i,j));
%         squashed1(i-1,1)=temp;
%     end
% end
% 
% for i=2:size(expStats2,1)
%     temp="";
%     for j=1:4
%         temp=append(temp,expStats2(i,j));
%         squashed2(i-1,1)=temp;
%     end
% end
% for i=1:size(dataTable,1)
%     if dataTable(i,1)=='IHC'
% end


% expStats=sortrows(expStats,5);
