%% add circle/ribbon manually
%% ribbon manual
%% image proccessing
col=[];
row=[];
i=0;
imshow(allFiltered(:,:,20,2))
message = sprintf('Left click to manually add circle to ROI.\nRepeat if needed');
uiwait(msgbox(message)); %% halts the code
while 1
    i=i+1;
roi = impoint(); % can use imfreehand to draw my irregular area of intereset
% get the mask
   mask = roi.createMask;
 % extract the boundarybox of the ROI
   S = regionprops(mask,'Centroid');
   row(i)=S.Centroid(1);
   col(i)=S.Centroid(2);
m=questdlg('Would you like to continue?','','Yes','No','No');
switch m
    case 'Yes'
        continue
    case 'No'
        break
    
end

end
imshow(allFiltered(:,:,20,2))
cent=[row' col']
hold on
scatter(cent(:,1),cent(:,2),'r')
hold off
%% end
