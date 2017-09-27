function [fval, grad] = comp(h, shift)
    g1 = zeros(2*length(h),1);
    g2 = zeros(2*length(h),1);
    g1(1:length(h)) = h;
    g2(1+shift:length(h)+shift) = h(end:-1:1);
    
    fval = g1.' * g2;
    grad = g1(1+shift:length(h)+shift);    
end