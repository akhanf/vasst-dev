
function computeTractDistanceMetric (in_vtk_1,in_vtk_2,out_haus_txt,out_mean_txt)


[hausDist meanDist]=computeBundleDistanceMetrics(readTractsFromVTK(in_vtk_1),readTractsFromVTK(in_vtk_2));
dlmwrite(out_haus_txt,hausDist);
dlmwrite(out_mean_txt,meanDist);

end
