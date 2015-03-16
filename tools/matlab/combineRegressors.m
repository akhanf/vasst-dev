function  combineRegressors( in_txts, out )
%combineRegressors Concatenates several FSL FEAT regressor files


data=[];
for i=1:length(in_txts)
    data=[data, importdata(in_txts{i})];
end

dlmwrite(out,data,' ')

end

