function score=evaluateScore(coords,storeCenters,storeRadii)
score2=0;
for i = 1:size(storeCenters,1)
    distance=(((coords(:,1)-storeCenters(i,1)).^2)+((coords(:,2)-storeCenters(i,2)).^2)).^(.5);
    if min(distance)<mean(storeRadii)
        score2=score2+1;
    else
        score2=score2-1;
    end
end
score=score2/size(coords,1);

end