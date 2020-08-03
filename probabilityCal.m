function [p]=probabilityCal(Z) 
Z_sqr = Z.^2;
Z_sum = sum(Z_sqr(:));
Z_colm_sum = sum(Z_sqr);
p = Z_colm_sum./Z_sum;
end