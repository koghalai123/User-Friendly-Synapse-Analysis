%Part of the regraphing preocess. im pretty sure it removes the other
%ribbon/density overlays so that new one can be added

function sliceValidationRMEmpty(app)
temp=app.ribbon;
newStruct=struct([]);
for b =1:2
    counter=1;
    for i = 1:size(temp(b).grouped,2)
        if size(temp(b).grouped(i).grouped,1)>0
            newStruct(b).grouped(counter).grouped=temp(b).grouped(i).grouped;
            counter=counter+1;
        end
    end
end
app.ribbon=newStruct;

end