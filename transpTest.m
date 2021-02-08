X = 1:20;
Y = 1:20;
Z = 1:20;
V = rand(20,20,20);
% space slices out without the data
sx = linspace(min(X(:)),max(X(:)),7);
sy = linspace(min(Y(:)),max(Y(:)),4);
sz = linspace(min(Z(:)),max(Z(:)),8);
% create the slices 
% in this example, there are 19 surfaces created
h = slice(X, Y, Z, V, sx, sy, sz);
% set properties for all 19 objects at once using the "set" function
set(h,'EdgeColor','none',...
    'FaceColor','interp',...
    'FaceAlpha','interp');
% set transparency to correlate to the data values.
alpha('color');
colormap(jet);