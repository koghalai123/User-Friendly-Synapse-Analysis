function saveData(app,fileName,nucleusData,ribbonData,voxel,R1Scat,R2Scat,NAssociated,RAssociated,presynaptic,postsynaptic,dimensions)
% 
% saveData(fileName,nucleusData,ribbonData,voxel,R1Scat,R2Scat,NAssociated,RAssociated)
%
%   saveData saves the data from the GUI as a .mat file as well as in xl
%   files for easy usage by non-programmers. The files are then put into a
%   folder
% 
%   fileName is the name of the file that the user will name the files
%   nucleusData is the centers and radii of the nuclei
%   ribbonData is the structure containing the ribbons grouped by the
%   clustering algorithm
%   voxel is a matrix with the voxel data
%   R1Scat is the scatter objects of the presynaptic ribbons
%   R2Scat is the scatter objects of the postsynaptic densities
%   NAssociated is the matrix with nuclei that could be associated to
%   ribbons
%   RAssociated is a structure of associated ribbons to the nuclei.
% 
% 
% 
% 

% txtFile=fopen(fileName,'w');
% fprintf(txtFile,'%-s \n','Voxel Data');
% fprintf(txtFile,'%-15f %-15f %-15f \n',voxel(1),voxel(2),voxel(3));
% 
% 
% 
% fprintf(txtFile,'%-s \n','Nucleus Data');
% fprintf(txtFile,'%-15s %-15s %-15s %-15s \n','XData(micron)','YData(micron)','ZData(micron)','Radius(micron)');
% for i = 1:size(nucleusData,1)
%     fprintf(txtFile,'%-5i) %-15.3d %-15.3d %-15.3d %-15.3d \n',i,nucleusData(i,1),nucleusData(i,2),nucleusData(i,3),nucleusData(i,4));
% end
% txtArr=["Presynaptic Data";"Postsynaptic Data"];
% for b=1:2
%     fprintf(txtFile,'%-s \n',txtArr(b));
%     fprintf(txtFile,'%-15s %-15s %-15s %-15s \n','XData(micron)','YData(micron)','ZData(micron)','Height(micron)');
% 
%     for i =1:size(ribbonData(b).grouped,2)
%         X=mean(ribbonData(b).grouped(i).grouped(:,1))*voxel(1);
%         Y=mean(ribbonData(b).grouped(i).grouped(:,2))*voxel(2);
%         Z=mean(ribbonData(b).grouped(i).grouped(:,3))*voxel(3);
%         H=((max(ribbonData(b).grouped(i).grouped(:,3))-min(ribbonData(b).grouped(i).grouped(:,3)))/2)*voxel(3);
%         fprintf(txtFile,'%-5i) %-15.3d %-15.3d %-15.3d %-15.3d \n',i,X,Y,Z,H);
%     end
% end
% 
% fclose(txtFile);





%Saving for easy use in Excel
XLFileNames=[strcat(fileName,"Pre.xlsx");strcat(fileName,"Post.xlsx");strcat(fileName,"Nuc.xlsx");strcat(fileName,"VecPre.xlsx");strcat(fileName,"VecPost.xlsx")];
for b = 1:2
    temp=zeros(size(ribbonData(b).grouped,2),4);
    for i = 1:size(ribbonData(b).grouped,2)
        temp(i,1:4)=[mean(ribbonData(b).grouped(i).grouped(:,1))*voxel(1),mean(ribbonData(b).grouped(i).grouped(:,2))*voxel(2),mean(ribbonData(b).grouped(i).grouped(:,3))*voxel(3),((max(ribbonData(b).grouped(i).grouped(:,3))-min(ribbonData(b).grouped(i).grouped(:,3))))*voxel(3)];
    end
    tab=array2table(temp);
    tab.Properties.VariableNames = {'X(Micron)','Y(Micron)','Z(Micron)','Height(Micron)'};
    writetable(tab,XLFileNames(b));
end
nucTab=array2table(nucleusData);
nucTab.Properties.VariableNames = {'X(Micron)','Y(Micron)','Z(Micron)','Radius(Micron)'};
writetable(nucTab,XLFileNames(3));

% R1Tab=array2table([transpose(R1Scat.XData),transpose(R1Scat.YData),transpose(R1Scat.ZData)]);
% R1Tab.Properties.VariableNames = {'X(Micron)','Y(Micron)','Z(Micron)'};
% writetable(R1Tab,XLFileNames(4));
% 
% R2Tab=array2table([transpose(R2Scat.XData),transpose(R2Scat.YData),transpose(R2Scat.ZData)]);
% R2Tab.Properties.VariableNames = {'X(Micron)','Y(Micron)','Z(Micron)'};
% writetable(R2Tab,XLFileNames(5));

%Saving for easy usage in Matlab
saveInOrigForm={'Nucleus Data','Presynaptic Ribbon Data','Postsynaptic Ribbon Data','Voxel Data','R1Scat','R2Scat','NAssociated','RAssociated','ribbonVar','Presynaptic Channel','Postsynaptic Channel','Dimensions','Voxel';nucleusData,ribbonData(1).grouped,ribbonData(2).grouped,voxel,R1Scat,R2Scat,NAssociated,RAssociated,ribbonData,presynaptic,postsynaptic,dimensions,voxel};
origFormName=strcat(fileName,"OrigData.mat");
save(origFormName,'saveInOrigForm');


%Move all the files to a folder
folderName=strcat(fileName,"Data");
mkdir(folderName)

allNames=[origFormName;XLFileNames];

for i = 1:4%size(allNames,1)
    movefile(allNames(i),folderName);
end