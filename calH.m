function [ H ] = calH( X )
[N,M] = size(X);

H = [];

%calculat H
for m = 1:M    
    set = unique(X(:,m));
    col = X(:,m);
    for k = 1:size(set,1)              
        set_col = repmat(set(k,1),N,1);
        H(:,end+1) = (set_col == col);
        if(length(nonzeros(H(:,end)))<2)
            H(:,end) = [];
        end
    end
end

end

