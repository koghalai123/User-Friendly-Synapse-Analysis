function [presynaptic,postsynaptic]=matchChannelToOrgan(allData,storeCenters,storeRadii)
    
    indices=randi(size(storeCenters,1), [round(size(storeCenters,1)/300),1]);
    miniStoreCenters=round([storeCenters(indices,:),storeRadii(indices,:)]);
    channelSum=zeros(2,1);
    for b = 2:3
        for i=1:size(miniStoreCenters)
            validX=max(miniStoreCenters(:,1)-miniStoreCenters(:,3),1):4:min(miniStoreCenters(:,1)+miniStoreCenters(:,3),size(allData,1));
            validY=max(miniStoreCenters(:,2)-miniStoreCenters(:,3),1):4:min(miniStoreCenters(:,2)+miniStoreCenters(:,3),size(allData,1));
            [allX,allY]=meshgrid(validX,validY);
            reshapedX=allX(:);
            reshapedY=allY(:);
            meanInNuc=mean(allData(reshapedX,reshapedY,miniStoreCenters(i,3),b),'all');
            channelSum(b-1)=meanInNuc+channelSum(b-1);
        end
    end


    
    if channelSum(1)>channelSum(2)
        presynaptic=2;
        postsynaptic=3;
    else
        
        presynaptic=3;
        postsynaptic=2;
    end
    
    
    
    
end