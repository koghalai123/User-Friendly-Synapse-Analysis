

function [Radii,Centers,DCircles,DRadii] = findStats(app,type,slice)
% 
% [Radii,Centers,DCircles,DRadii] = findStats(app,type,slice)
%
%   Radii is a matrix containing the radii of a circle cast by a nucleus on a particular
%   slice, based on its center and radius(or the ribbon positions,
%   depending on whether the user was looking fornuclei of ribbons)
%   Centers is a matrix containing the centers of the organ cast onto this
%   slice
%   DCircles are the discarded instances of this organ. It allows for the
%   user to check whether an organ is being detected or being clusterd out
%   of the data due to bad settings
%   DRadii contains the radii instead of the centers
% 
%   app is the GUI
%   type is the type of organ
%   slice is what slice the user wants the data for.
%
%
%
DCircles=[];
DRadii=[];
    if type==1 %check if we are finding data for nucleus or ribbons
        Centers=[];
        Radii=[];
        counter=1;
        for i = 1:size(app.NCenters,1)
            %Use voxel data and pixel locations to find how large each
            %circle should be, given a z plane and sphere center and radius
            if app.NRadii(i)^2>(app.NCenters(i,3)-slice*app.voxel(3))^2
                Radii(counter)=((((app.NRadii(i))^2)-((app.NCenters(i,3)-slice*app.voxel(3))^2))^(.5))/app.voxel(1);
                Centers(counter,:)=[app.NCenters(i,1)/app.voxel(1),app.NCenters(i,2)/app.voxel(2),app.NCenters(i,3)/app.voxel(1)];
                counter=counter+1;
            end
        end
        %Show which data points were discarded
        A=app.discardedN(:,3)==slice;
        DCircles=app.discardedN(A,1:2);
        DRadii=app.discardedN(A,4);

    elseif type==2%check if we are finding data for nucleus or ribbons
        %Look for discarded ribbon locations, as well as the kept ribbon
        %locations on this particular slice.
        if size(app.discardedRPre,1)>0
            A=app.discardedRPre(:,3)==slice;
            DCircles=app.discardedRPre(A,:);
            DRadii=app.RRadEditField.Value;
        end
        
        Centers=app.presynapticPositions(slice).points;
        Radii=str2double(app.RRadEditField.Value);
        
    elseif type==3
        if size(app.discardedRPost,1)>0
            A=app.discardedRPost(:,3)==slice;
            DCircles=app.discardedRPost(A,:);
            DRadii=app.RRadEditField.Value;
        end
        
        Centers=app.postsynapticPositions(slice).points;
        Radii=str2double(app.RRadEditField.Value);
        
    end
end