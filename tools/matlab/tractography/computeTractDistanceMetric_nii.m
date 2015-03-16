
function computeTractDistanceMetric_nii (in_nii_1,in_nii_2,out_mean_txt,out_haus_txt)
    
    
[hausDist meanDist]=computeBundleDistanceMetrics_nii(in_nii_1,in_nii_2);
dlmwrite(out_haus_txt,hausDist);
dlmwrite(out_mean_txt,meanDist);


end
