

%transform 2D image with linear flirt xfm

function applyTransformPNG ( in_png, ref_png, flirt_xfm, png_res, out_png, inverse)

	%bgnd val for hist pngs
	histfillval=244;

        T=importdata(flirt_xfm);
        T=T([1 2 4],[1 2 4]);
        
        %applyxfm to pix coords
        sform=eye(3); %vox to phys
        sform(1,1)=png_res;
        sform(2,2)=png_res;
        if inverse==1
        Tcomp=inv(sform)*inv(T)*sform;
        else
        Tcomp=inv(sform)*T*sform;
        end
        
        Tfm=maketform('affine',Tcomp');
        R = makeresampler('linear', 'fill');
        
        %origin of nii and pngs are different..
        % so flip image after reading and before writing    
        
        image=imread(in_png);
        refimage=imread(ref_png);
        
        refimage=flipdim(flipdim(refimage,1),2);
        image=flipdim(flipdim(image,1),2);

        warpimage=imtransform(image,Tfm,'XData',[1 size(refimage,2)],'YData',[1 size(refimage,1)],'FillValues',histfillval);
        warpimage=flipdim(flipdim(warpimage,1),2);
        imwrite(warpimage,out_png);
        
        
end
