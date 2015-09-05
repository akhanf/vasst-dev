% by alik, modified by jlau
% takes as input pre-processed fMRI subject data and computes time series, correlation, partial correlation
% modified 20150904 before being committed to git

function [C,T,V]=getConnectivitySubj(subj,label_csv)

  work_dir=pwd;

  [lbl,timeseries] = textread([label_csv],'%d %*d %*s %*s %*s %*s %s','delimiter',',');

  M=140; % length of time series
  N=length(lbl);

  C=zeros(N);
  P=zeros(N);
  T=zeros(N,M);

  for i=1:N
    %get T (time series) for each label
    T(i,:)=load(sprintf('%s/%s/fmri/HarvardOxford-combined-prob_ts/%s',work_dir,subj,char(timeseries(i))));
  end

  %subtract out global (mean of all ROI) timeseries
%  T=T-repmat(mean(T,1),N,1);

  %compute correlations
  for i=1:N
    for j=i:N
      C(i,j)=corr(T(i,:)',T(j,:)');

      % partial correlation correcting for all other ROIs not i or j
      k = setdiff( 1:N, [i j] ); % k = all elements not i or j
      P(i,j) = partialcorr( T(i,:)', T(j,:)', T(k,:)' );
    end
  end

  %ensure similarity down to numerical precision.. (symmetric matrix)
  C = C + C' - eye(N);
  P = P + P' - eye(N);
  
  % create output mat file for each of time series, corr matrix, pcorr matrix
  out_mat=sprintf('%s/%s/fmri/HarvardOxford-combined-ts.mat',work_dir,subj);
  save(out_mat, 'T');

  out_mat=sprintf('%s/%s/fmri/HarvardOxford-combined-fconn.mat',work_dir,subj);
  save(out_mat, 'C');

  out_mat=sprintf('%s/%s/fmri/HarvardOxford-combined-pcorr.mat',work_dir,subj);
  save(out_mat, 'P');

end
