function [X] = colSampling(Z,d, opts)

% step 3.1: Compute  C
    [C] = calC(Z,opts);   
    A = C*C'; 
    A = (A+A')/2;
% step 3.2: Compute eign B matrix
    [U,E] = eigs(A,d+1);
    E = diag(E); 
    [E_sort,ind] = sort(E,1,'descend');
    X0 = U(:,ind(2:d+1));
    
%     E_sort_half_inv = diag(E_sort(2:d+1,:));
    
    E_sort_half_inv = diag(1./sqrt(E_sort));
    E_sort_half_inv = E_sort_half_inv(2:d+1,2:d+1);

    X = C'*X0*E_sort_half_inv;
end