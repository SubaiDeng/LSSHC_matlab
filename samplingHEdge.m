function [Z_samp ] = samplingHEdge(Z ,L,mode)
% sampling hyperedge
% mode : 
% k : kmeans
% r : random
% p : probability

% step 1: calculate the probability
[p] = probabilityCal(Z);
p = full(p).*1000;
% step 2: select landmark
switch mode
    
    case 'k'
        [Z_samp,lx] = lmarks(Z',L,'kmeans');        
        Z_samp = Z_samp'; 
    case 'r'        
        [Z_samp,lx] = lmarks(Z',L,'random');             
        Z_samp = Z_samp'; 
    case 'p'        
        [Z_samp,lx]= probabilitySampling(Z,L);
    otherwise        
        fprint('Error type of sampling the hyperedge.\n');      
end

% step 4:  scale matrix
    N = size(Z,1);
    p = p(:,lx);
    Z_samp = Z_samp./repmat(((L*p).^0.5),N,1);
    
% step 5:  normalized matrix
% DC = sum(C,2); DDC = diag(sparse(DC.^(-1))); Z = DDC*C;
end