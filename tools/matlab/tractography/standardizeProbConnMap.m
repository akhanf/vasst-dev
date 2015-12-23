function  standardizeProbConnMap( in_nii,out_nii )
%standardizeProbConnMap Performs rescaling of FSL probabilistic
%connectivity maps based on power-law fitting 

        
        nbins=200;
        
        nii=load_nifti(in_nii);
        vol=nii.vol();
        vol(vol==0)=nan;
        [counts,centers]=hist(vol(:),nbins);

        f=fit(centers',counts','power1','Robust','LAR');
                
        vol_scaled=nii.vol();
     %   vol_scaled=(vol_scaled./f.a).^(-1/f.b);
       % vol_scaled=((vol_scaled).^(-1/f.b))./f.a;
       %vol_scaled=(vol_scaled).^(-1/f.b);

       vol_scaled=vol_scaled.^(-1/f.b).*(f.a^(1/f.b));
       
       %other:
%        
%        vol=vol_scaled;
% vol_scaled(vol_scaled==0)=nan;
% [counts_sc,centers_sc]=hist(vol_scaled(:),nbins);
% figure; loglog(centers,counts);
% 
% 
% 
         nii.vol=vol_scaled;
        
        
        
        save_nifti(nii,out_nii);
        
end

