function [ U,S,V ] = calEigenvector( Z,k,opts )
%   Detailed explanation goes here
%        CASE 1 : n >> m (m is small, using SVD) 
%        CASE 2 : n & m are big   (Column sampling)  
%        CASE 3 : n & m are big   (VN method)

mode = opts.mode;
samp_mode = opts.samp_mode;
L =  opts.l;

switch mode
% CASE 1: did not approximate W = Z*Z^T
    case 1  
        [U,S,V] = mySVD(Z,k+1);
% CASE 2:
    case 2
        [Z_samp] = samplingHEdge(Z,L,samp_mode);
        Z_hat = Z_samp;
        [U,S,V] = mySVD(Z_hat,k+1);
% CASE 3:  column sampling W_hat =  Z_hat*Z_hat^T
    case 3     
        [Z_samp] = samplingHEdge(Z,L,samp_mode);
        C = Z'* Z_samp;
        Z_hat = C;
        [U,S,V] = approximateSVD(Z_hat, C ,k+1,Z, mode);
% CASE 4:
    case 4
        [Z_samp] = samplingHEdge(Z,L,samp_mode);
        C = Z'* Z_samp;
        Z_hat = Z*C;     
        tmp_m = Z_hat'*Z_hat;
        [U,S,V] = approximateSVD(Z_hat, C ,k+1,Z, mode);
% CASE 5:
    case 5
        [Z_samp] = samplingHEdge(Z,L,samp_mode);
        C = Z'*Z_samp;
        Z_hat = Z_samp;
        [U,S,V] = approximateSVD(Z_hat, C ,k+1,Z, mode);
        
    otherwise
        fprint('Error type of calculate the matrix eign.\n');
end

U(:,1) = [];
n = size(U,2);
if(n > k)
    U(:,1) = [];
    n = k;
end
% U=U(:,1:k);
% n = n-1;% TEST
U=U./repmat(sqrt(sum(U.^2,2)),1,n);
end

