function [ result,ac ] = qualityMetric( C , X )
%qualityMetric Summary of this function goes here
%   Detailed explanation goes here
%   X a vector of the true label of point
%   C a matrix of the cluster
Z = C;
B = X';

N = size(B,2);
for i = 1: N
    [a1,a2] = find (Z(:,i));
    Z(a1,i) = B(1,i);
end
Z(Z==0) =NaN;
m = mode(Z,2);
M = diag(m);
Z = M*C;
A = sum(Z,1);
result= nmi(A,B);
ac = length(find(B == A))/length(B);
end

