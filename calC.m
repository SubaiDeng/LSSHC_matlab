function[C] = calC(Z,opts)

% if isfield(opts,'mode')
%     mode = opts.mode;
% end
% 
% if strcmp(mode,'kmeans')
%     %select landmark using kmeans
%    
% elseif strcmp(mode,'random')
%     %random select landmark
% end

% # of the landmark
l = opts.l; 
mode = opts.mode;

% step 1: select landmark from H matrix, Get H_hat matrix.
%mode: r : random select 
%      k : kmeans
%      p : probability 

[H_hat] = lmarks(Z,l, mode );

% step 2: scale the sampling H_hat matrix  C(t) = A(it)/sqrt(c*p(i,j))
[H_hat] = scaleHMatrix(H_hat);

% step 3: construct C matrix: C = H_hat'*H;
C = H_hat'*H;

% step 4: normalized  D_1^(-1/2)*C*D_2^(-1/2)
DC = sum(C,2); DDC = diag(sparse(DC.^(-1))); Z = DDC*C;


% select landmark 
% random select &  kmeans selecet
% CASE 1:

% CASE 2:

% CASE 3:

[Y0,lx] = lmarks(Z,1000);
C = Y0*Z';

end