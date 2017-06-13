function out_coords = warpHistNiiCoordsFlirt( in_coords, flirt_xfm,inverse);
% takes in phys coords and warps using flirt 


    %    in_coords=[18.1,21.2; 7.6,25.5; 7.6,25.5]; %each row is diff coord
    %    inverse=0;
     %   flirt_xfm='flirt_EPI_P006_A04_NEUN-HE.xfm'

        
        
                
        T=importdata(flirt_xfm);
        T=T([1 2 4],[1 2 4]);
        
        if inverse==1
        T=inv(T);
        end
        
        out_coords=zeros(size(in_coords));
        
        N=size(in_coords,1);
        for i=1:N
            inx=[in_coords(i,:)'; 1];
            outx=T*inx;
            out_coords(i,:)=outx(1:2)';
        end
end