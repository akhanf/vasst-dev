function  standardizeProbConnMap( in_nii,out_nii )
%standardizeProbConnMap Performs rescaling of FSL probabilistic
%connectivity maps based on power-law fitting 

        
        nbins=200;
        
        nii=load_nifti(in_nii);
        vol=nii.vol();
        vol(vol==0)=nan;
        [counts,centers]=hist(vol(:),nbins);

        f=fit(centers',counts','power1');
                
        vol_scaled=nii.vol();
        vol_scaled=(vol_scaled./f.a).^(-1/f.b);
        
        nii.vol=vol_scaled;
        
        save_nifti(nii,out_nii);
        
end

