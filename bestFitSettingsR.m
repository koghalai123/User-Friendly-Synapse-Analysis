function settingsArray=bestFitSettingsR(MLFigure,data,medRange,threshold,epsilon,minGroup,range,radius,minimum,maximum)
isNucleus=false;

startValue=1;
stopValue=0;

UIAxes=MLFigure.Children;
plotHandles=UIAxes.Children;
for i = 1:size(plotHandles,1)-1
    coords(i,1:2)=[plotHandles(i,1).XData,plotHandles(i,1).YData];
end



THI=10;
MRI=10;
EPI=10;

TH=linspace(.06,.1,THI+1);

EP=linspace(6,13,EPI+1);

minMed=4;
maxMed=14;
MR=transpose([linspace(minMed,maxMed,MRI+1);linspace(minMed,maxMed,MRI+1)]);

scores=zeros(THI,MRI,EPI);
settings=fopen('settingsR1.txt','w');
counter=1;

scores=zeros(THI,MRI,EPI);

settingsArray=[];
tic
for thresh = 1:THI
    for MRange = 1:MRI
        for EPSIL=1:EPI
            allFiltered=initialThreshold(TH(thresh+1),MR(MRange+1,:),data,isNucleus,minimum,maximum);
            [ribbons]=ribbonStuff(allFiltered,EP(EPSIL),minGroup,range,startValue,stopValue);
            score=evaluateScore(coords,ribbons,radius*2);
            
            
            scores(thresh,MRange,EPSIL)=score;
            fprintf(settings,'R1S. EPS: %d MR: %i TH: %d Score: %d \n',EP(EPSIL),MR(MRange+1,:),TH(thresh+1),score);
            fprintf(settings,'\n');
            if score==1
                settingsArray(counter,:)=[SE(Sense),MR(MRange+1,1),TH(thresh+1)];
                counter=counter+1;
            end
            
            
            
        end
    end
end
toc
end