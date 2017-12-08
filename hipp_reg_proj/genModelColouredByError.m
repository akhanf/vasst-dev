
% Brian, point this script to your data here:
fn=('V073/labels/t2/checkerboard/checkerboard.l.10.reorient.06mm.affineAtlasSpace.crop.nii.gz');
errorPerBin = importdata('eucDistDir/avgDistDir/BSpline_t2/avgAllSubj.l.10.dist_mm.txt');%<load error per bin here, as a list of 100 scalar values>
errorPerBin(:,1) = [];
errorPerBin = [NaN;errorPerBin];
errorPerBin = [errorPerBin(1:90);NaN;errorPerBin(91:end)];
errorPerBin = [errorPerBin(1:94);NaN;errorPerBin(95:end)];
errorPerBin = [errorPerBin;NaN;NaN;NaN];

%% this should handle the rest:

checkerboard = load_nifti(fn);


% make 3d model
[gmx,gmy,gmz] = ind2sub(size(checkerboard.vol),find(checkerboard.vol>0)); % x y z indexes of all points
shp = alphaShape(gmx,gmy,gmz,1); % NOTE THIS SHOULD BE ~8, JORDAN CHANGED IT TO 1
[tri,p] = alphaTriangulation(shp);

%interpolate bins outside hippocampus to make sure vertices that are just outside
%hippocampus get a checkerbin assigned to them
checkerboard.vol(checkerboard.vol==0) = nan;
[Xq, Yq, Zq] = ind2sub(size(checkerboard.vol),find(~isnan(checkerboard.vol)));
F = scatteredInterpolant(Xq,Yq,Zq,checkerboard.vol(~isnan(checkerboard.vol)),'nearest','nearest');
[Xq, Yq, Zq] = ind2sub(size(checkerboard.vol),find(isnan(checkerboard.vol)));
checkerboardinterp.vol = checkerboard.vol;
checkerboardinterp.vol(isnan(checkerboard.vol)) = F(Xq,Yq,Zq);

% swap in error values for bin numbers
for bin = 1:100
    checkerboardinterp.vol(checkerboardinterp.vol==bin) = errorPerBin(bin);
end

% now get corresponding error value at each vertex
for n = 1:length(p)
    C(n,1) = checkerboardinterp.vol(p(n,1),p(n,2),p(n,3));
end
C(isnan(C)) = 0;

% plot
figure;
trisurf(tri,p(:,1),p(:,2),p(:,3),C);
axis equal
colormap('jet')

% NOTE: if you want to save this as a .stl or other model type, you'll have
% to download MATLAB function to do that