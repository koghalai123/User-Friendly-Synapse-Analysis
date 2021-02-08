%this uses the nuclei to find the rotation angle
%It does all the graphs from the validated data
%This is the one that should be used right now
angleMatElev=zeros(287,20);
angleMatAzim=zeros(287,20);
angleMatPolarTheta=zeros(287,20);




% for i=2:159
% saveInOrigForm{2, 2}(i).grouped=[];
% end
for fileNum=1:287
    try
        close all;
        %
        dataStorageLocation='F:\RibbonAnalysisDataSets\Final';
        matlabPath='C:\Users\togha\Documents\MATLAB\OghalaiLabRibbonAnalysis';
        
        
        
        %Load data
        
        folderName=strcat(num2str(fileNum),'Final');
        movefile(strcat(dataStorageLocation,'\',folderName),matlabPath);
        addpath(folderName);
        
        nucFileName=strcat(num2str(fileNum),'FinalNuc.xlsx');
        nucData=table2array(readtable(nucFileName));
        preFileName=strcat(num2str(fileNum),'FinalPre.xlsx');
        preData=table2array(readtable(preFileName));
        postFileName=strcat(num2str(fileNum),'FinalPost.xlsx');
        postData=table2array(readtable(postFileName));
        load(strcat(num2str(fileNum),'FinalMat.mat'));
        movefile(folderName,dataStorageLocation);
        
        voxelData=saveInOrigForm{2, 4};
        IHCStereociliaFile='ReticularLaminaPointsMatched.xlsx';
        sterociliaTable=readtable(IHCStereociliaFile);
        
        voxelData=saveInOrigForm{2, 4};
        IHCStereociliaFile='ReticularLaminaPointsMatched.xlsx';
        stereociliaTable=readtable(IHCStereociliaFile);
        for i=1:3:34
            toSwitchVar=table2array(stereociliaTable(fileNum,i:i+2)).*voxelData;
            stereociliaMat(floor(i/3)+1,:)=toSwitchVar;
        end
        
        points=[stereociliaMat(10,:);stereociliaMat(11,:);stereociliaMat(12,:)];
        
        
        numNuc=size(nucData,1);
        opts = statset('Display','iter','MaxIter',10000);
        
        
        %1 indicates pre, 2 indicates post scale it to be length measurements
        bothData=[preData(:,1:3),ones(size(preData,1),1);postData(:,1:3),2*ones(size(postData,1),1)];
        
        alteredBothData=[1.5*preData(:,1),preData(:,2)/3,1.5*preData(:,3),ones(size(preData,1),1);1.5*postData(:,1),postData(:,2)/3,1.5*postData(:,3),2*ones(size(postData,1),1)];
        
        %cluster analysis on ribbon clouds
        [idxBoth,CBothAltered] = kmedoids(alteredBothData,numNuc,'Options',opts,'PercentNeighbors',1,'Replicates',20);
        
        for a=1:numNuc
            inGroup=bothData(idxBoth==a,:);
            CBoth(a,:)=mean(inGroup);
        end
        
        
        
        % [idxPre,CPre] = kmedoids([preData(:,1),preData(:,2)/3,preData(:,3)],numNuc,'PercentNeighbors',1);
        % [idxPost,CPost] = kmedoids([postData(:,1),postData(:,2)/3,postData(:,3)],numNuc,'PercentNeighbors',1);
        
        fGrouped=figure();
        fGrouped.Name='Clouds Matched To Nuclei';
        axesGrouped=axes(fGrouped);
        axis(axesGrouped,'equal');
        hold(axesGrouped,'on');
        
        fManyVecs=figure();
        fManyVecs.Name='Individual Flattened Normalized Vector Plot';
        
        fManyPolarPre=figure();
        fManyPolarPre.Name='Individual Normalized Polar Plot Presynaptic(needs to be checked)';
        fManyPolarPost=figure();
        fManyPolarPost.Name='Individual Normalized Polar Plot Postsyanptic(needs to be checked)';
        
        %Sort the centers of the ribbon clouds and the nuclei to match up each
        %cloud to a nucleus
        
        sortedNuc=sortrows(nucData,1);
        nearestGrouping=dsearchn([CBoth(:,1),CBoth(:,2),CBoth(:,3)],[sortedNuc(:,1),sortedNuc(:,2),sortedNuc(:,3)]);
        sortedBoth=CBoth(nearestGrouping,:);
        %sortedBoth=sortrows(CBoth);
        
        vecAdjPre=[];
        vecAdjPost=[];
        polarAdjPre=[];
        polarAdjPost=[];
        
        
        %Polynomial fit(x) and linear fit(y) for the IHC Stereocilia+graphing the points I used
        quadFit1=polyfit(points(1:3,1),points(1:3,2),2);
        quadFit2=polyfit(points(1:3,1),points(1:3,3),2);
        x=linspace(0,100,1000);
        y=quadFit1(1).*x.^2+quadFit1(2).*x+quadFit1(3);
        
        stereociliaLineFit=fitlm(points(1:3,1),points(1:3,3));
        z=table2array(stereociliaLineFit.Coefficients(1,1))+table2array(stereociliaLineFit.Coefficients(2,1))*x;
        plot3(axesGrouped,x,y,z)
        scatter3(axesGrouped,points(:,1),points(:,2),points(:,3))
        
        
        prePolarTheta=[];
        postPolarTheta=[];
        prePolarRho=[];
        postPolarRho=[];
        prePolarRad=[];
        postPolarRad=[];
        
        polarBinEdges=linspace(0,2*3.1415,10);
        
        for i=1:numNuc
            
            r=0;
            g=rand;
            b=rand;
            
            
            set(0,'CurrentFigure',fGrouped);
            scatter3(axesGrouped,sortedNuc(i,1),sortedNuc(i,2),sortedNuc(i,3),2000,[r,g,b],'Marker','.')
            
            %Find the ribbons for this nucleus
            [row,~]=find(sortedBoth(i,1)==CBoth(:,1));
            validBoth=idxBoth==row;
            
            inGroup=bothData(validBoth,:);
            
            [rowPre,~]=find(inGroup(:,4)==1);
            [rowPost,~]=find(inGroup(:,4)==2);
            
            b3x=sortedNuc(i,1);
            b3y=sortedNuc(i,2)-(quadFit1(1).*b3x.^2+quadFit1(2).*b3x+quadFit1(3));
            b3z=sortedNuc(i,3)-(quadFit2(1).*b3x.^2+quadFit2(2).*b3x+quadFit2(3));
            
            b1=fitlm(sortedNuc(:,1),sortedNuc(:,3)); %for rho
            b2=fitlm(sortedNuc(:,1),sortedNuc(:,2)); %for theta
            
            
            
            phiDiff=atan(b3z/b3y); %vertical rotation about x axis
            thetaDiff=atan(table2array(b2.Coefficients(2,1)));  %horizontal rotation about z axis
            rhoDiff=atan(table2array(stereociliaLineFit.Coefficients(2,1)));  %horizontal rotation about y axis
            scatter3(axesGrouped,inGroup(rowPre,1),inGroup(rowPre,2),inGroup(rowPre,3),10,[r,g,b],'Marker','*');
            scatter3(axesGrouped,inGroup(rowPost,1),inGroup(rowPost,2),inGroup(rowPost,3),10,[r,g,b],'Marker','o');
            %
            %
            %
            
            vecPre=[inGroup(rowPre,1)-sortedNuc(i,1),inGroup(rowPre,2)-sortedNuc(i,2),inGroup(rowPre,3)-sortedNuc(i,3)];
            vecPost=[inGroup(rowPost,1)-sortedNuc(i,1),inGroup(rowPost,2)-sortedNuc(i,2),inGroup(rowPost,3)-sortedNuc(i,3)];
            
            [azPre,elevPre,rPre]=cart2sph(vecPre(:,1),vecPre(:,2),vecPre(:,3));
            [azPost,elevPost,rPost]=cart2sph(vecPost(:,1),vecPost(:,2),vecPost(:,3));
            
            [xPre,yPre,zPre]=sph2cart(azPre,elevPre-phiDiff,rPre);
            [xPost,yPost,zPost]=sph2cart(azPost,elevPost-phiDiff,rPost);
            
            [polarAzPre,~]=cart2pol(xPre,zPre);
            [polarAzPost,~]=cart2pol(xPost,zPost);
            
            [polarElevPre,preRadius]=cart2pol(xPre,yPre);
            [polarElevPost,postRadius]=cart2pol(xPost,yPost);
            
            vecAdjPre=[vecAdjPre;xPre,yPre,zPre];
            vecAdjPost=[vecAdjPost;xPost,yPost,zPost];
            polarAdjPre=[polarAdjPre;azPre,elevPre-phiDiff,rPre];
            polarAdjPost=[polarAdjPost;azPost,elevPost-phiDiff,rPost];
            
            angleMatElev(fileNum,i)=mean([elevPre;elevPost]);
            angleMatAzim(fileNum,i)=mean([elevPre;elevPost]);
            angleMatPolarTheta(fileNum,i)=mean([polarAzPre;polarAzPost]);
            
            
            prePolarTheta=[prePolarTheta;polarAzPre];
            postPolarTheta=[postPolarTheta;polarAzPost];
            prePolarRho=[prePolarRho;polarElevPre];
            postPolarRho=[postPolarRho;polarElevPost];
            prePolarRad=[prePolarRad;preRadius];
            postPolarRad=[postPolarRad;postRadius];
            
            set(0,'CurrentFigure',fManyVecs);
            rows=ceil(numNuc/5);
            subplot(rows,5,i)
            hold on;
            scatter(xPre,zPre,10,[1,0,0],'Marker','o');
            scatter(xPost,zPost,10,[0,1,0],'Marker','*');
            axLim=max(abs([fManyVecs.CurrentAxes.XLim,fManyVecs.CurrentAxes.YLim]));
            fManyVecs.CurrentAxes.XLim=[-1*axLim,axLim];
            fManyVecs.CurrentAxes.YLim=[-1*axLim,axLim];
            fManyVecs.CurrentAxes.XGrid='on';
            fManyVecs.CurrentAxes.YGrid='on';
            hold off;
            
            set(0,'CurrentFigure',fManyPolarPre);
            rows=ceil(numNuc/5);
            subplot(rows,5,i,polaraxes)
            hold on;
            polarhistogram((polarAzPre),'BinEdges',polarBinEdges);
            hold off;
            
            set(0,'CurrentFigure',fManyPolarPost);
            
            rows=ceil(numNuc/5);
            subplot(rows,5,i,polaraxes)
            hold on;
            polarhistogram((polarAzPost),'BinEdges',polarBinEdges);
            hold off;
        end
        
        %graph the ribbon clouds that were not matched up to a nucleus in red
        combinedMat=[nearestGrouping;transpose(1:numNuc)];
        uniqueVals=unique(combinedMat);
        % Find the unique values
        
        % Count the number of instances of each of the unique vals
        valCount = hist( combinedMat(:,1) , uniqueVals )';
        notGraphed=CBoth((valCount==1),:);
        for i=1:size(notGraphed,1)
            set(0,'CurrentFigure',fGrouped);
            [row,~]=find(notGraphed(i,1)==CBoth(:,1));
            validBoth=idxBoth==row;
            
            inGroup=bothData(validBoth,:);
            
            [rowPre,~]=find(inGroup(:,4)==1);
            [rowPost,~]=find(inGroup(:,4)==2);
            
            scatter3(axesGrouped,inGroup(rowPre,1),inGroup(rowPre,2),inGroup(rowPre,3),10,[1,0,0],'Marker','*');
            scatter3(axesGrouped,inGroup(rowPost,1),inGroup(rowPost,2),inGroup(rowPost,3),10,[1,0,0],'Marker','o');
            % %
        end
        
        
        nucFitLineZ=table2array(b1.Coefficients(1,1))+table2array(b1.Coefficients(2,1))*x;
        nucFitLineY=table2array(b2.Coefficients(1,1))+table2array(b2.Coefficients(2,1))*x;
        
        plot3(axesGrouped,x,nucFitLineY,nucFitLineZ);
        axis(axesGrouped,'equal');
        view(axesGrouped,3);
        hold off;
        fVecPlot=figure;
        fVecPlot.Name='Combined Normalized Vector Plot';
        axesVecPlot=axes(fVecPlot);
        hold on;
        axis(axesVecPlot,'equal');
        scatter3(axesVecPlot,vecAdjPre(:,1),vecAdjPre(:,2),vecAdjPre(:,3),10,[1,0,0],'Marker','*');
        scatter3(axesVecPlot,vecAdjPost(:,1),vecAdjPost(:,2),vecAdjPost(:,3),10,[0,1,0],'Marker','o');
        scatter3(axesVecPlot,0,0,0,2000,[0,0,0],'Marker','.');
        axLim=5+max(abs([axesVecPlot.XLim,axesVecPlot.YLim,axesVecPlot.ZLim]));
        axesVecPlot.XLim=[-1*axLim,axLim];
        axesVecPlot.YLim=[-1*axLim,axLim];
        axesVecPlot.ZLim=[-1*axLim,axLim];
        axesVecPlot.XGrid='on';
        axesVecPlot.YGrid='on';
        axesVecPlot.ZGrid='on';
        view(3);
        hold off;
        
        fPolarPlot=figure;
        fPolarPlot.Name='Combined Normalized Polar Plot';
        
        axesPolarPlot1=polaraxes(fPolarPlot,'OuterPosition',[0,0,.5,1]);
        axesPolarPlot2=polaraxes(fPolarPlot,'OuterPosition',[.5,0,.5,1]);
        
        p1=polarhistogram(axesPolarPlot1,prePolarTheta,'BinEdges',polarBinEdges);
        p2=polarhistogram(axesPolarPlot2,postPolarTheta,'BinEdges',polarBinEdges);
        
        
        %nearest ribbon for synapse matching
        binEdges=[0:.05:10];
        
        [preK,preDist]=dsearchn(postData,preData);
        [postK,postDist]=dsearchn(preData,postData);
        fMatchingSynapseDistancesFromPre=figure();
        fMatchingSynapseDistancesFromPre.Name='Distances From Presynaptic';
        histogram(preDist,'BinEdges',binEdges);
        
        fMatchingSynapseDistancesFromPost=figure();
        fMatchingSynapseDistancesFromPost.Name='Distances From Postsynaptic';
        histogram(postDist,'BinEdges',binEdges);
        
        
        
        save(strcat(num2str(fileNum),'PrePolarTheta.mat'),'prePolarTheta');
        save(strcat(num2str(fileNum),'PostPolarTheta.mat'),'postPolarTheta');
        save(strcat(num2str(fileNum),'PrePolarRho.mat'),'prePolarRho');
        save(strcat(num2str(fileNum),'PostPolarRho.mat'),'postPolarRho');
        save(strcat(num2str(fileNum),'PrePolarRad.mat'),'prePolarRad');
        save(strcat(num2str(fileNum),'PostPolarRad.mat'),'postPolarRad');
        
        saveas(fGrouped,strcat(num2str(fileNum),'RibGroupedToNucPlot'));
        saveas(fPolarPlot,strcat(num2str(fileNum),'CombinedPolarPlot'));
        saveas(fVecPlot,strcat(num2str(fileNum),'NormalizedVectorPlot'));
        saveas(fManyPolarPre,strcat(num2str(fileNum),'IndividualPolarPlotPre'));
        saveas(fManyPolarPost,strcat(num2str(fileNum),'IndividualPolarPlotPost'));
        saveas(fManyVecs,strcat(num2str(fileNum),'FlattenedVectorPlot'));
        saveas(fMatchingSynapseDistancesFromPre,strcat(num2str(fileNum),'HistogramDistFromPre'));
        saveas(fMatchingSynapseDistancesFromPost,strcat(num2str(fileNum),'HistogramDistFromPost'));
        
        mkdir(strcat(num2str(fileNum),'PlotsAndData'));
        
        movefile(strcat(num2str(fileNum),'PrePolarTheta.mat'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'PostPolarTheta.mat'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'PrePolarRho.mat'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'PostPolarRho.mat'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'PrePolarRad.mat'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'PostPolarRad.mat'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'RibGroupedToNucPlot.fig'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'CombinedPolarPlot.fig'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'NormalizedVectorPlot.fig'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'IndividualPolarPlotPre.fig'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'IndividualPolarPlotPost.fig'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'FlattenedVectorPlot.fig'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'HistogramDistFromPre.fig'),strcat(num2str(fileNum),'PlotsAndData'));
        movefile(strcat(num2str(fileNum),'HistogramDistFromPost.fig'),strcat(num2str(fileNum),'PlotsAndData'));
        
        movefile(strcat(num2str(fileNum),'PlotsAndData'),'Data');
        % plot3(x,y,z)
        clearvars -except angleMatAzim angleMatElev
    catch
        clearvars -except angleMatAzim angleMatElev
    end
end
