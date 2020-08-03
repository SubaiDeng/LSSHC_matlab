% [Y0,lx] = lmarks(Y,L[,method]) Select L landmarks from a dataset
%
% This selects L landmarks from the data Y in one of the following two ways:
% - at random from the data, and then removing 20% of the landmarks that are
%   closest to each other;
% - as the centroids of k-means.
%
% In:
%   Y: NxD matrix of N row D-dimensional vectors.
%   L: number of landmarks.
%   method: how to select landmarks, 'random' or 'kmeans'. Default: 'random'.
% Out:
%   Y0: LxD matrix of L row D-dimensional vectors, the landmarks.
%   lx: 1xL list of the indices of the landmarks in Y: Y0=Y(lx,:).
%
% Any non-mandatory argument can be given the value [] to force it to take
% its default value.

% Copyright (c) 2013 by Max Vladymyrov and Miguel A. Carreira-Perpinan

function [Y0,lx] = lmarks(Y,L,method)

% ---------- Argument defaults ----------
if ~exist('method','var') || isempty(method) method='random'; end
% ---------- End of "argument defaults" ----------

switch method 
 case 'kmeans'
  tmp = round(L*0.2);		% add 20% more points temporarily
  [~,mu] = litekmeans(Y,L+tmp);
  [~,lx] = min(sqdist(Y,mu));
  lx = unique(lx);
  mu = Y(lx,:);
  if length(lx)>L		% remove excess points (at random)
    ind = randperm(length(lx));
    lx = lx(ind(1:L));		% landmark index
  end
  Y0 = Y(lx,:);
 case 'random'
  tmp = round(L*0.2);		% add 20% more points temporarily
  N = size(Y,1);
  lx = randperm(N);
  lx = lx(1:(L+tmp));
  Y0 = Y(lx,:);
  % Remove points that are closest to each other
  sqd = sqdist(Y0);
  sqd(1:L+tmp+1:(L+tmp)^2) = Inf;
  [~,ind] = sort(min(sqd));	% find closest landmarks
  Y0(ind(1:2:2*tmp),:) = [];
  lx(ind(1:2:2*tmp)) = [];
end

