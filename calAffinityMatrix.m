function [z] = calAffinityMatrix(H,W)


[N,M] = size(H);

if nargin < 2
    W = repmat((1),M,1);
end


D_v_temp = H .* repmat(W',N,1);
D_v = sum(D_v_temp,2);
D_v_inv_half = 1./(sqrt(D_v)+10^(-6));
D_e_inv_half = 1./(sqrt(sum(H,1))+10^(-6));
W_e_half = sqrt(W);

z = repmat(D_v_inv_half,1,M).* H .*repmat(W_e_half',N,1) .* repmat(D_e_inv_half,N,1);


% feaSum = full(sqrt(sum(H,1)));
% feaSum = max(feaSum, 1e-12);
% z = H./feaSum(ones(size(H,1),1),:);


% A = D_v_temp*D_e_inv*H';


