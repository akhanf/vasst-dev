function stain_img = getStainChannel(img,stain_type)



switch stain_type
    case {'NEUN','GFAP'}
      %  disp('H DAB');
        
        in_mod=[ 0.650, 0.704, 0.286;  %Haem
            0.268, 0.570, 0.776;  %DAB
            0, 0, 0];
        
        MOD=createColourDeconvolveMatrix(in_mod);
        
        
        %save second channel
        
        stain_img=computeColourDeconvolve(img,MOD);
 %       stain_imgH=stain_img(:,:,1); %Haem
        stain_img=stain_img(:,:,2); %DAB
       
%       figure;imagesc(stain_imgH(100:500,70:500,:));axis off;axis equal;  
%       figure;imagesc(stain_img(100:500,70:500,:));axis off;axis equal;

        
    case 'LUXFB'
        
    in_mod =[    0.6622    0.2764    0.1070;
                    0.8520    0.5107    0.4389;
                    0         0         0];

    MOD=createColourDeconvolveMatrix(in_mod);

    %save first channel
	stain_img=computeColourDeconvolve(img,MOD);
    
	stain_img=stain_img(:,:,1);
    stain_img(stain_img<0)=0;
    
    %stain_img=(255-stain_img(:,:,1))./255
    %stain_img=(stain_img(:,:,1)-255)./(stain_img(:,:,1));
    
    
        
    otherwise
        disp('Unknown staining!');
        exit 0
        
end




end
        
