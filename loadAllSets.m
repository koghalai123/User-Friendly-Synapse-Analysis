%Not being used

for fileNum=80:200
     dataFile=strcat(num2str(fileNum),'.czi');

    addPathString=strcat('F:\RibbonAnalysisDataSets\BlindedData\',dataFile);
    movefile(addPathString,'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');

    DFPath=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',dataFile);



    bfReader=bfGetReader();

    bfReader.setId(dataFile);


    fileName=strcat(num2str(fileNum),'Mini');


    numIm=bfReader.getImageCount();
    allData=uint16(zeros(500,500,floor(numIm/20),3));
    for i =0:20:numIm-4
        for b =1:3
            plane=bfGetPlane(bfReader,i+b);
            allData(:,:,floor(i/40)+1,b)=uint16(imresize(plane,[800,800]));
        end
    end

    saveDataInParFor(fileName,allData)




     bfReader.close();

    moveNewDataStr=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',fileName,'.mat');
    rmPathString=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',dataFile);
    movefile(rmPathString,'F:\RibbonAnalysisDataSets\BlindedData');
    movefile(moveNewDataStr,'F:\RibbonAnalysisDataSets\MiniData')

end

function saveDataInParFor(fileName,allData)
    save(fileName,'allData','-v7.3');
end