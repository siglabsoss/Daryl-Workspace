% ftest2.m

N = 1024;
M = 128;

h = dpss(N,N*(1.0/M),1);

[hvalue, hindex] = max(h)

m = zeros(N,1);
for index =-M/2:M/2-1
    m = m + exp(2j*pi*((0:N-1).'-hindex) * index / M);
end

figure();
plot(real(m)); hold on;
plot(imag(m), 'r'); hold off;
