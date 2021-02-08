function proxyFunc(app)
    %testing
    
    checkData3D(app,app.plainData,str2double(app.CheckData3DDropDown.Value),app.newCenters,app.ribbon(1).grouped,app.ribbon(2).grouped,app.imageSize,[app.NChEditField.Value,app.PreChEditField.Value,app.PostChEditField.Value,app.LastChEditField.Value],app.resizedDimensions,app.voxel,app.dimensions);
end