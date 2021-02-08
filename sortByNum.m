%not being used
fileName='dataIdentifiers.xlsx';
opts = detectImportOptions(fileName,'Sheet',2);
raw = readcell(fileName,opts);

names=["Names"];
for i=2:size(raw,1)
    names(i,1)=convertCharsToStrings(raw{i, 1});
end



[sorted,idx] = sort(cell2mat(raw(2:end,2))); 

stringMat=string(sorted);
stringMat(:,2)=raw(idx+1,1);
% sortedmat = mat(idx,:);
% sortedmat = mat(idx,:);