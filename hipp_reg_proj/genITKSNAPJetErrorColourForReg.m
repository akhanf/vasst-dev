
f=importdata('eucDistDir/avgDistDir/BSpline_GM/avgAllSubj.l.10.dist_mm.txt');
errorPerBin(:,1)=f(:,2);

f=importdata('eucDistDir/avgDistDir/BSpline_GM_DB/avgAllSubj.l.10.dist_mm.txt');
errorPerBin(:,2)=f(:,2);

f=importdata('eucDistDir/avgDistDir/BSpline_t1/avgAllSubj.l.10.dist_mm.txt');
errorPerBin(:,3)=f(:,2);

f=importdata('eucDistDir/avgDistDir/BSpline_t2/avgAllSubj.l.10.dist_mm.txt');
errorPerBin(:,4)=f(:,2);

errorPerBin = [NaN,NaN,NaN,NaN;errorPerBin];
errorPerBin = [errorPerBin(1:90,:);NaN,NaN,NaN,NaN;errorPerBin(91:end,:)];
errorPerBin = [errorPerBin(1:94,:);NaN,NaN,NaN,NaN;errorPerBin(95:end,:)];
errorPerBin = [errorPerBin;NaN,NaN,NaN,NaN;NaN,NaN,NaN,NaN;NaN,NaN,NaN,NaN];



errorPerBin(isnan(errorPerBin)) = 0;


errorPerBin = (errorPerBin-min(min(errorPerBin)))/max(max(errorPerBin))*999+1;
errorPerBin = round(errorPerBin);
rgbjet = jet(1000);
rgbjet = round(rgbjet*255);


template = tblread('ITKSNAPlabeldescriptionstemplate.nohdr.txt');

for n = 1:100
    template(n,:) = template(1,:);
    template(n,1) = n;
    template(n,2:4) = rgbjet(errorPerBin(n,4),:);
end


% tblwrite(template,'itksnaperrorcolorbins.txt','delimiter','/t');