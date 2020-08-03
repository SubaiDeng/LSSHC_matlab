function [ H ] = pretreatmentKmeans( X );
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
K = 6;
[N,M] = size(X);
H = [];
for i = 1:M
    x_col = X(:,i);
    [res,center]=litekmeans(x_col,K,'MaxIter',100,'Replicates',1);
    cen_col=[];
    for j = 1:length(res)
        cen_col(j,1)=center(res(j));
    end
    temp = abs(x_col - cen_col);
    delta = max(temp)+0.01;
    e_col=exp(-temp.^2/(2*delta));
    
       
    set = unique(res);
    for k = 1:size(set,1)              
        set_col = repmat(set(k,1),N,1);
        H(:,end+1) = (set_col == res);
    end
    
    H(:,end-k+1:end)= H(:,end-k+1:end).*repmat(e_col,1,k);
    
%     disp(i);
end

end

