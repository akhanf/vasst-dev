function [faces, vertices] = readTriByu(filename,fixedwidth)
% [faces, vertices] = readTriBYU(filename,fixedwidth)
% Reads a BYU file if it holds a triangulated mesh
%
% filename - path to BYU file
% fixedwidth - 0 or 1 refers to which style of byu file (whether numbers are spaced into fixed width columns)
% vertices - vertices of the BYU file
% edges - vector of indices into the vertex array. polygons are made from 
%       consecutive edges, with the final edge of each polygon being negated.
%       i.e. [1;4;3;-5;1;2;-3;1;5;-3] would describe a quadrangle and 2
%       triangless
% parts - vector delineating which edges belong in which parts
if nargin<2
    fixedwidth = 0;
end
[parts,vertices,edges] =readBYUSurface(filename,fixedwidth);
faces = abs(reshape(edges,3,[])');
