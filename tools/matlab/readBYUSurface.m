function [parts,vertices,edges] = readBYUSurface(filename,fixedwidth)
% [parts,vertices,edges] = readBYUSurface(filename,fixedwidth)
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

[fid,message] = fopen(filename,'rt');
if fid<0
    error('mial:dataIO:FailOpenForRead', 'Could not open the file %s for reading: %s', filename,message);
end
if fixedwidth
    header = fgetl(fid);
    C = str2num(reshape(header,8,4)');

    parts = [];
    while size(parts,1)<C(1)
        s=fgetl(fid);
        parts = [parts;reshape(str2num(reshape(s,8,[])'),2,[])'];
    end

    vertices = [];
    while size(vertices,1)<C(2)*3
        s=fgetl(fid);
        vertices = [parts;reshape(str2num(reshape(s,18,[])'),3,[])'];
    end


    edges = [];
    while size(edges,1)<C(4)
        s=fgetl(fid);
        edges = [parts;reshape(str2num(reshape(s,8,[])'),1,[])'];
    end
else
    C=textscan(fid,'%d32',4);
    partnum = C{1}(1);
    vertexnum = C{1}(2);
    polynum = C{1}(3);
    edgenum = C{1}(4);

    P = textscan(fid, '%d32',partnum+1);
    V = textscan(fid, '%n', vertexnum*3);
    E = textscan(fid, '%d32',edgenum);
    parts=P{1};
    vertices = reshape(V{1},3,[])';
    edges = E{1};
end
fclose(fid);
