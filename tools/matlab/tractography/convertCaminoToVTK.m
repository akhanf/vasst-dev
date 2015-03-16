function convertCaminoToVTK (in_bfloat,out_vtk)

tracts=readCaminoTracts(in_bfloat);
scalars=ones(length(tracts),1);
writeTractsToVTK(tracts,scalars,out_vtk);

end