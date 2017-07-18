function writeTriByu(filename, triangles, vertices)
% writeTriByu(filename, triangles, vertices)
% Writes a triangular mesh to BYU format
% filename - path to BYU file to create
% vertices - Mx3 matrix of vertex coordinates
% triangles - Mx3 matrix of indices into the vertices matrix
dlmwrite(filename, [1 size(vertices,1) size(triangles,1) size(triangles,1)*3], 'delimiter', ' ', 'precision', '%i') ;

% $$$ dlmwrite(filename, [1 size(triangles,1)*3], '-append', 'delimiter', ' ', 'precision', '%i') ;

%EDIT: Karteek Popuri (karteek.pop@gmail.com) on Jan 22, 2014.
%In the .byu format the second line should be the number of triangles as opposed to 3*number of triangles. 
%So, line 12 is commented out and has been replaced by line 17.

dlmwrite(filename, [1 size(triangles,1)], '-append', 'delimiter', ' ', 'precision', '%i') ;
dlmwrite(filename, vertices, '-append', 'delimiter', ' ', 'precision', '%f') ;
dlmwrite(filename, [triangles(:,1) triangles(:,2) triangles(:,3)], '-append', 'delimiter', ' ', 'precision', '%i') ;
