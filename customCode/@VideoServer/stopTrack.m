function[]=stopTrack(videoServer)
try
if videoServer.enable_preview
    close(videoServer.preview_figure_handle);
end
catch ee
end
if videoServer.enable_auto_update
    stop(videoServer.timerCam);
    delete(videoServer.timerCam);
end
delete(videoServer.IRcam);
delete(videoServer.RGBcam);
end