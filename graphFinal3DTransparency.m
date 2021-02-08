%not sure if it is being used.

function graphFinal3DTransparency(allData,dimensions)

%define spatial data
X = 1:dimensions(1);
Y = 1:dimensions(2);
Z = 1:dimensions(3);

%define image data
V = allData(:,:,:,1);

% space slices out without the data
sx = linspace(min(X(:)),max(X(:)),7);
sy = linspace(min(Y(:)),max(Y(:)),4);
sz = linspace(min(Z(:)),max(Z(:)),8);

% create the slices 
h = slice(X, Y, Z, V, sx, sy, sz);
% set properties for all 19 objects at once using the "set" function
set(h,'EdgeColor','none',...
    'FaceColor','interp',...
    'FaceAlpha','interp');
% set transparency to correlate to the data values.
alpha('color');
colormap(jet);