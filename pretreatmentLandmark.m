function [ Z ] = pretreatmentLandmark( data, opts )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set and parse parameters
if (~exist('opts','var'))
   opts = [];
end


% # of the landmark
p = 1000;
if isfield(opts,'p')
    p = opts.p;
end

% the # nearest neighbour landmark
r = 5;
if isfield(opts,'r')
    r = opts.r;
end

%
maxIter = 100;
if isfield(opts,'maxIter')
    maxIter = opts.maxIter;
end


numRep = 10;
if isfield(opts,'numRep')
    numRep = opts.numRep;
end



% the mode of select landmark
% mode = 'kmeans';
% mode = 'random';
if isfield(opts,'mode')
    mode = opts.mode;
end


nSmp=size(data,1);

% Landmark selection
if strcmp(mode,'kmeans')
    
    %k-means select landmark
    kmMaxIter = 3;
    if isfield(opts,'kmMaxIter')
        kmMaxIter = opts.kmMaxIter;
    end
    kmNumRep = 1;
    if isfield(opts,'kmNumRep')
        kmNumRep = opts.kmNumRep;
    end
    [dump,marks]=litekmeans(data,p,'MaxIter',kmMaxIter,'Replicates',kmNumRep);
    clear kmMaxIter kmNumRep
    
elseif strcmp(mode,'random')
    %ramdom select landmark
    indSmp = randperm(nSmp);
    marks = data(indSmp(1:p),:);% random select landmark
    clear indSmp
else
    error('mode does not support!');
end


% Z construction
D = EuDist2(data,marks,0);

if isfield(opts,'sigma')
    sigma = opts.sigma;
else
    sigma = mean(mean(D));
end


% find the r nearest landmarks
dump = zeros(nSmp,r);
idx = dump;
for i = 1:r
    [dump(:,i),idx(:,i)] = min(D,[],2);
    temp = (idx(:,i)-1)*nSmp+[1:nSmp]';
    D(temp) = 1e100; 
end


dump = exp(-dump/(2*sigma));
% dump = exp(-dump/(2*sigma^2));
sumD = sum(dump,2);
Gsdx = dump;
% Gsdx = bsxfun(@rdivide,dump,sumD);
Gidx = repmat([1:nSmp]',1,r);
Gjdx = idx;
Z=sparse(Gidx(:),Gjdx(:),Gsdx(:),nSmp,p);

% Graph decomposition
% 
% feaSum = full(sqrt(sum(Z,1)));
% feaSum = max(feaSum, 1e-12);
% Z = Z./feaSum(ones(size(Z,1),1),:);


end

