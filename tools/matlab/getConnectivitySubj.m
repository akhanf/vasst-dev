% by alik, modified by jlau
% takes as input pre-processed fMRI subject data and computes correlation matrix from it
%  also requires the label csv file

function [C,T]=getConnectivitySubj(subj,label_csv)

  work_dir=pwd;

  [lbl,name,timeseries]=textread([label_csv],'%d %*d %s %*s %*s %*s %s','delimiter',',');

  M=140; % length of time series
  N=length(lbl);

  C=zeros(N);
  T=zeros(N,M);

  %testing out effect of both subtracting mean TS and not
  C2=zeros(N);
  T2=zeros(N,M);

  for i=1:N
    %get T (time series) for each label
    T(i,:)=load(sprintf('%s/%s/fmri/HarvardOxford-combined-prob_ts/%s',work_dir,subj,timeseries{i}));
  end

  %subtract out global (mean of all ROI) timeseries (globesub)
  T2=T-repmat(mean(T,1),N,1);

  %compute correlations
  for i=1:N
    for j=i:N
      C(i,j)=corr(T(i,:)',T(j,:)');
      C2(i,j)=corr(T2(i,:)',T2(j,:)');
    end
  end

  %ensure similarity down to numerical precision.. (symmetric matrix)
  C=C+C'-eye(N);

  C2=C2+C2'-eye(N);

  out_mat=sprintf('%s/%s/fmri/HarvardOxford-combined-fconn.mat',work_dir,subj);
  save(out_mat, 'C');

  out_mat=sprintf('%s/%s/fmri/HarvardOxford-combined-ts.mat',work_dir,subj);
  save(out_mat, 'T');

  %global time series subtracted from each individual ROI; a test
  out_mat=sprintf('%s/%s/fmri/HarvardOxford-combined-fconn_globesub.mat',work_dir,subj);
  save(out_mat, 'C2');

  out_mat=sprintf('%s/%s/fmri/HarvardOxford-combined-ts_globesub.mat',work_dir,subj);
  save(out_mat, 'T2');

%    imagesc(C); colormap('jet'); colorbar;

%    out_fig=sprintf('%s/%s/fmri/HarvardOxford-combined-fconn.png',work_dir,subj);
%    saveas(gcf, out_fig, 'png'); % png output

end
