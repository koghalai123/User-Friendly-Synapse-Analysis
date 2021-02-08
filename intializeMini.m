%not being used

for fileNum=2:10
    limsFileName=strcat(num2str(fileNum),'YZLims.mat');
    load(limsFileName);
    XLims=[1,2048];
    YLims=[1,2048];
    ZLims=round([lims.ribLims(2,1),lims.ribLims(2,2)]);
    
    dataFile=strcat(num2str(fileNum),'.czi');

    addPathString=strcat('F:\RibbonAnalysisDataSets\BlindedData\',dataFile);
    movefile(addPathString,'C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis');

    DFPath=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',dataFile);

    bfReader=bfGetReader();

    bfReader.setId(dataFile);   
    numIm=bfReader.getImageCount();
    allData=single(zeros(YLims(2)-YLims(1)+1,XLims(2)-XLims(1)+1,1,2));
    i = 4*round((ZLims(2)+ZLims(1))/2);
    for b =2:3
        plane=(bfGetPlane(bfReader,i+b));
        allData(:,:,1,b-1)=plane(YLims(1):YLims(2),:);
    end
    
    bfReader.close();

    fileName=strcat(num2str(fileNum),'LimMiniData');
    save(fileName,'allData','-v7.3');
    
    moveNewDataStr=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',fileName,'.mat');
    rmPathString=strcat('C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis\',dataFile);
    movefile(rmPathString,'F:\RibbonAnalysisDataSets\BlindedData');
    movefile(moveNewDataStr,'F:\RibbonAnalysisDataSets\MiniData2048x2048')

    clear all;
    
    
end