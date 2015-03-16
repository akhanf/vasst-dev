function combineTractsVTK(in_vtk_1,in_vtk_2,out_vtk)

tracts_1=readTractsFromVTK(in_vtk_1);
tracts_2=readTractsFromVTK(in_vtk_2);

combined=[tracts_1;tracts_2];
scalars=zeros(length(combined),1);
writeTractsToVTK(combined,scalars,out_vtk);

end
