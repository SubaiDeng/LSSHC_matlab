function [X] = vnMethod( Z,d,opts)

% step 3.1: Compute  C
    [C] = calC(Z,opts);    
% step 3.2: Compute W_hat = CMC
	% Affinity matrix A for the reduced spectral problem (landmarks-only)
    Z_hat = C*Z;
    A = Z_hat*Z_hat';
    A = (A+A')/2; 
    B = C*C'; 
    B = (B+B')/2;
%       step 3.3  Compute eign of W_hat




% Solve the reduced spectral problem. We can do this either by solving a
% generalized or a standard eigenvalue problem. They have a similar runtime.
% The solution through the generalized eigenvalue problem:
opts.issym = 1; opts.isreal = 1; opts.disp = 0;

[U,E] = eigs(A,B,d+1,'lm',opts); 
% [U,E] = eigs(A,d+1);
E = diag(E); 
[~,ind] = sort(E,1,'descend');
X0 = U(:,ind(2:d+1));

X = C'*X0;

end