
function [bundle_names,bundle_labels]=getBundleNamesLabelsTractXML (in_xml)


max_java_memory = java.lang.Runtime.getRuntime.maxMemory;

 foo=xmlread(in_xml);
 
bundle_nodes=foo.getElementsByTagName('Data').item(0).getElementsByTagName('Bundles').item(0).getElementsByTagName('Node');

bundle_labels=[];
for i=0:(bundle_nodes.getLength-1)
valnode=bundle_nodes.item(i).getElementsByTagName('Value').item(0);
if ~isempty(valnode)
value=str2num(valnode.getTextContent);
bundle_labels=[bundle_labels; value];
end
end


bundle_names=cell(length(bundle_labels),1);
j=1;
for i=0:(bundle_nodes.getLength-1)
namenode=bundle_nodes.item(i).getElementsByTagName('Name').item(0);
valnode=bundle_nodes.item(i).getElementsByTagName('Value').item(0);
if ~isempty(valnode)
name=char(namenode.getTextContent);
bundle_names{j}=name;
j=j+1;
end

end

end