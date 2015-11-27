function  convertTractsMRTrixToVTK( in_trk, out_vtk )
%convertTractsMRTrixToVTK Converts mrtrix format tracts to VTK

tracts=read_mrtrix_tracks(in_trk);
writeTractsToVTK(tracts.data,[],out_vtk);

end

