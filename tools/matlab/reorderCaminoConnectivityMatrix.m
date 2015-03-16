
function reorderCaminoConnectivityMatrix (input_conmat_csv,input_label_list_txt,output_mat)

conmat=importdata(input_conmat_csv);

lut=readtable(input_label_list_txt,'Delimiter',' ','ReadVariableNames',false);

%first, create LUT to go from input index to output index
index_lut=zeros(size(lut,1),1);

for i=1:length(index_lut)
    index_lut(i)=find(strcmp(conmat.textdata{i},lut.Var2));
end

connectivity=zeros(length(index_lut));

%want to fill in new connectivity matrices with converted indices
for i=1:length(index_lut)
    for j=1:length(index_lut)
        
        i_c=index_lut(i);
        j_c=index_lut(j);
        connectivity(i_c,j_c)=conmat.data(i,j);
    end
end

save(output_mat,'connectivity');


end

