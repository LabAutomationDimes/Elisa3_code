function[]=closeAll(elisas,vid)
    for i=1:length(elisas)
        elisas(i).stop();
    end
    vid.stopTrack();
end