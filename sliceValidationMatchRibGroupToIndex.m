%no idea what this one does
function sliceValidationMatchRibGroupToIndex(app)
for b =1:2
    for i = 1:size(app.ribbon(b).grouped,2)
        app.ribbon(b).grouped(i).grouped(:,4)=i;
    end
    
end

end