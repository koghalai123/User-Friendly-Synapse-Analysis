function []=getThatScroll(obj,event,g,app)
% 
% []=getThatScroll(obj,event,g,app)
%
%   getThatScroll is a callback function that allows the user to scroll
%   between different slices of the 3D stack of hgtransforms
%    
%   obj is the figure
%   event is the scroll event
%   g is the 3D stack of hgtransforms
%   app is the GUI
% 
% 
% 

%Find how many slices are visible
on=findobj(g,'Visible',1);
off=findobj(g,'Visible',0);
%If the scroll is one way, make things invisible, else, make things visible
if event.VerticalScrollCount>0 && size(on,1)>2
    len=size(on,1);
    on(len).Visible=0;
    on(len/2).Visible=0;
    %This makes the scatter objects also visible/invisible on each slice.
    if nargin==4
        s=size(on,1)/2;
        scat=findobj(app.Scat3D,'UserData',s);
        set(scat,'Visible',0);
    end
elseif event.VerticalScrollCount<0 && size(off,1)>0
    len=size(off,1);
    off(1).Visible=1;
    off(1+len/2).Visible=1;
    if nargin==4
        s=size(on,1)/2;
        scat=findobj(app.Scat3D,'UserData',s+1);
        set(scat,'Visible',1);
    end
end


end