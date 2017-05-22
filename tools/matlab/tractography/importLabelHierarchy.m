
function importLabelHierarchy(in_nrrd,out_folder)
% imports bundle-based rules from synaptive NRRD atlas into nifti files, with contains/excludes

mkdir(out_folder);


[nrrd,meta]=nrrdread(in_nrrd);
nii_file=sprintf('%s.nii.gz',in_nrrd);
system(sprintf('c3d %s -o %s',in_nrrd,nii_file));
nii=load_nifti(nii_file);
delete(nii_file);
atlas_seg=nii.vol;





%% load labels

filename=sprintf('/tmp/header.%3.3g.txt',rand*1000);
system(sprintf('grep -a label %s > %s',in_nrrd,filename));

fid=fopen(filename);

i=1;
labels=[];
while ~feof(fid)
    
    
    D=fscanf(fid,'%s:=%s\n');
        if(isempty(D))
        break
    end
    E=textscan(D,'%s','Delimiter',':=');
    
    linename=E{1}{1};
    
    %pull out the label type here
    linetype=textscan(linename,'%s','Delimiter','_');
    
    nodetype=linetype{1}{1};
    
    val=E{1}{3};
    
    F=textscan(val,'%s','Delimiter',',');
    
    if(length(F{1})>1)
        labelval=str2num(F{1}{2});
    else
        labelval=[];
    end
    
    labels{i,1}=F{1}{1};
    labels{i,2}=labelval;
    
    i=i+1;
    
end

fclose(fid);
delete(filename);


%% load edges



filename=sprintf('/tmp/header.%3.3g.txt',rand*1000);
system(sprintf('grep -a edge %s > %s',in_nrrd,filename));

fid=fopen(filename);

i=1;
edges=[];
while ~feof(fid)
    
    
    D=fscanf(fid,'%s:=%s\n');
        if(isempty(D))
        break
    end
    E=textscan(D,'%s','Delimiter',':=');
    
    linename=E{1}{1};
    
    %pull out the label type here
    linetype=textscan(linename,'%s','Delimiter','_');
    
    nodetype=linetype{1}{1};
    
    val=E{1}{3};
    
    F=textscan(val,'%s','Delimiter',',');
    

    
    edges{i,1}=F{1}{1};
    edges{i,2}=F{1}{2};
    
    
    i=i+1;
    
end

fclose(fid);
delete(filename);

%% add label hierarchy to graph
% parse nodes and edges

G=digraph;


G=addnode(G,{labels{:,1}});

for i=1:length(edges);
G=addedge(G,edges{i,1},edges{i,2});
end

label_nums=labels(:,2);
label_names=labels(:,1);
L=table(label_nums,'RowNames',label_names);


%% load bundle hierarchy


filename=sprintf('/tmp/header.%3.3g.txt',rand*1000);
system(sprintf('grep -a bundle %s > %s',in_nrrd,filename));

fid=fopen(filename);

i=1;

G_bundle=digraph;

while ~feof(fid)

    
    
    D=fscanf(fid,'%s:=%s\n');
    if(isempty(D))
        break
    end
    E=textscan(D,'%s','Delimiter',':=');
    
 %   linename=E{1}{1};

    
    %pull out the label type here
  %  linetype=textscan(linename,'%s','Delimiter','_');
    
  %  nodetype=linetype{1}{1};
    
    val=E{1}{3};
    
    F=textscan(val,'%s','Delimiter',',');

    node1=F{1}{1};
    node2=F{1}{2};
    
    G_bundle=addedge(G_bundle,node1,node2);

    
    
    i=i+1;
    
end

fclose(fid);
delete(filename);




%% load rules


filename=sprintf('/tmp/header.%3.3g.txt',rand*1000);
system(sprintf('grep -a rule %s > %s',in_nrrd,filename));
%system(sprintf('grep -a rule_47 %s > %s',in_nrrd,filename));

fid=fopen(filename);

i=1;





while ~feof(fid)
    
    
    D=fscanf(fid,'%s:=%s\n');
    if(isempty(D))
        break
    end
    E=textscan(D,'%s','Delimiter',':=');
    
    
    
    val=E{1}{3};
    
    F=textscan(val,'%s','Delimiter',',');

    bundle=F{1}{1};
    ruletype=F{1}{2};
    labellist=F{1}(3:end);
    
    seg=zeros(size(atlas_seg));
    for lbl=1:length(labellist)            
        rulelbls=dfsearch(G,labellist{lbl});
        nums=uint16(cell2mat(L.label_nums(rulelbls)));
        
        %write out image
        
        for j=1:length(nums)
            seg(atlas_seg==nums(j))=lbl;
        end
        
    end
    
    nii.vol=seg;
    save_nifti(nii,sprintf('%s/rule.%s.%s.nii.gz',out_folder,bundle,ruletype));
    
    i=i+1;
    
end

fclose(fid);
delete(filename);




%% plot it!
%figure; plot(G,'Layout','layered','NodeLabel',{labels{:,1}});

%figure; plot(G_bundle,'Layout','layered','NodeLabel',G_bundle.Nodes);

end
