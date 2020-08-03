function [ Z_samp,lx ] = probabilitySampling( Z, s)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Z_sqr = Z.^2;
Z_sum = sum(Z_sqr(:));
Z_colm_sum = sum(Z_sqr);
E = size(Z,2);
Z_samp = [];
lx = [];

while(s)
    randnum = Z_sum * rand();
    for i = 1:E
        if(randnum - Z_colm_sum(i) < 0)
            break;
        else
            randnum = randnum - Z_colm_sum(i);
        end
    end 
    Z_samp(:,end+1) = Z(:,i);
    lx(:,end+1)= i;
    s = s-1;
end

end

