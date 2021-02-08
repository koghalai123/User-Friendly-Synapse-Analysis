function settingsArray=bestFitSettingsN(MLFigure,data,threshold,medRange,range,radius,sensitivity,minimum,maximum)
UIAxes=MLFigure.Children;
plotHandles=UIAxes.Children;
for i = 1:size(plotHandles,1)-1
    coords(i,1:2)=[plotHandles(i,1).XData,plotHandles(i,1).YData];
end

startValue=1;
stopValue=0;
isNucleus=true;


settings=[];

THI=10;
MRI=10;
SEN=10;

TH=linspace(.08,.09,THI+1);

minMed=7;
maxMed=7;
MR=transpose([linspace(minMed,maxMed,MRI+1);linspace(minMed,maxMed,MRI+1)]);
SE=linspace(.96,.97,SEN+1);

scores=zeros(THI,MRI,SEN);
settings=fopen('settingsN.txt','w');
counter=1;

settingsArray=[];
for thresh = 1:THI
    for MRange = 1:1%MRI
        for Sense=1:SEN
            [allFiltered]=initialThreshold(TH(thresh+1),MR(MRange+1,:),data,isNucleus,minimum,maximum);
            [storeCenters,storeRadii]=viewPreliminaryData(allFiltered,range,SE(Sense),stopValue,startValue,radius);
            score=evaluateScore(coords,storeCenters,storeRadii);
            scores(thresh,MRange,Sense)=score;
            fprintf(settings,'NS. SEN: %d MR: %i TH: %d Score: %d \n',SE(Sense),MR(MRange+1,:),TH(thresh+1),score);
            fprintf(settings,'\n');
            if score==1
                settingsArray(counter,:)=[SE(Sense),MR(MRange+1,1),TH(thresh+1)];
                counter=counter+1;
            end
        end
    end
end
fclose(settings);


end