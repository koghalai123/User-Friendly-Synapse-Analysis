%Not being used

nucStorage='F:\RibbonAnalysisDataSets\PreliminaryData';
ribStorage='F:\RibbonAnalysisDataSets\FinalData';
matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
finalLocation='F:\RibbonAnalysisDataSets\Final';

% fileNum=1;
for fileNum=1:287
    try
        %move nucleus files
        folderNameNuc=strcat(num2str(fileNum),'FinalData');
        movefile(strcat(nucStorage,'\',folderNameNuc));
        addpath(folderNameNuc);

        nucXLFileName=strcat(num2str(fileNum),'FinalNuc.xlsx');
        nucData=readtable(nucXLFileName);
        movefile(folderNameNuc,nucStorage);

        %move ribbon files
        folderNameRib=strcat(num2str(fileNum),'FinalData');
        movefile(strcat(ribStorage,'\',folderNameRib));
        addpath(folderNameRib);
        
        matDataName=strcat(num2str(fileNum),'FinalOrigData.mat');
        preXLFileName=strcat(num2str(fileNum),'FinalPre.xlsx');
        postXLFileName=strcat(num2str(fileNum),'FinalPost.xlsx');

        preData=readtable(preXLFileName);
        postData=readtable(postXLFileName);
        load(matDataName);
        saveInOrigForm{2, 1}=table2array(nucData);
        
        movefile(folderNameRib,ribStorage);

        writetable(nucData,nucXLFileName);
        writetable(preData,preXLFileName);
        writetable(postData,postXLFileName);
        matFileName=strcat(num2str(fileNum),"FinalMat.mat");
        save(matFileName,'saveInOrigForm');
        
        finalFolderName=strcat(num2str(fileNum),'Final');
        mkdir(finalFolderName);
        movefile(nucXLFileName,finalFolderName);
        movefile(preXLFileName,finalFolderName);
        movefile(postXLFileName,finalFolderName);
        movefile(matFileName,finalFolderName);
        
        movefile(finalFolderName,finalLocation);
    catch
        try
            folderNameNuc=strcat(num2str(fileNum),'FinalNucCheckedData');
            movefile(strcat(ribStorage,'\',folderNameNuc));
            addpath(folderNameNuc);

            nucXLFileName=strcat(num2str(fileNum),'FinalNuc.xlsx');
            matDataName=strcat(num2str(fileNum),'FinalOrigData.mat');
            preXLFileName=strcat(num2str(fileNum),'FinalPre.xlsx');
            postXLFileName=strcat(num2str(fileNum),'FinalPost.xlsx');

            nucData=readtable(nucXLFileName);
            preData=readtable(preXLFileName);
            postData=readtable(postXLFileName);
            load(matDataName);
            saveInOrigForm{2, 1}=table2array(nucData);

            movefile(folderNameNuc,ribStorage);

            writetable(nucData,nucXLFileName);
            writetable(preData,preXLFileName);
            writetable(postData,postXLFileName);
            matFileName=strcat(num2str(fileNum),"FinalMat.mat");
            save(matFileName,'saveInOrigForm');

            finalFolderName=strcat(num2str(fileNum),'Final');
            mkdir(finalFolderName);
            movefile(nucXLFileName,finalFolderName);
            movefile(preXLFileName,finalFolderName);
            movefile(postXLFileName,finalFolderName);
            movefile(matFileName,finalFolderName);

            movefile(finalFolderName,finalLocation);
        catch
            try
                try
                    folderNameNuc=strcat(num2str(fileNum),'FinalNucCheckedData');
                    movefile(strcat(ribStorage,'\',folderNameNuc));
                    addpath(folderNameNuc);
                catch
                end

                nucXLFileName=strcat(num2str(fileNum),'FinalNucCheckedNuc.xlsx');
                matDataName=strcat(num2str(fileNum),'FinalNucCheckedOrigData.mat');
                preXLFileName=strcat(num2str(fileNum),'FinalNucCheckedPre.xlsx');
                postXLFileName=strcat(num2str(fileNum),'FinalNucCheckedPost.xlsx');
                
                
                consistentNameNuc=strcat(num2str(fileNum),'FinalNuc.xlsx');
                consistentMatDataName=strcat(num2str(fileNum),'FinalOrigData.mat');
                consistentNamePre=strcat(num2str(fileNum),'FinalPre.xlsx');
                consistentNamePost=strcat(num2str(fileNum),'FinalPost.xlsx');

                nucData=readtable(nucXLFileName);
                preData=readtable(preXLFileName);
                postData=readtable(postXLFileName);
                load(matDataName);
                saveInOrigForm{2, 1}=table2array(nucData);

                movefile(folderNameNuc,ribStorage);

                writetable(nucData,consistentNameNuc);
                writetable(preData,consistentNamePre);
                writetable(postData,consistentNamePost);
                matFileName=strcat(num2str(fileNum),"FinalMat.mat");
                save(matFileName,'saveInOrigForm');

                finalFolderName=strcat(num2str(fileNum),'Final');
                mkdir(finalFolderName);
                movefile(consistentNameNuc,finalFolderName);
                movefile(consistentNamePre,finalFolderName);
                movefile(consistentNamePost,finalFolderName);
                movefile(matFileName,finalFolderName);

                movefile(finalFolderName,finalLocation);
            catch
            end
        end
        
    end
end