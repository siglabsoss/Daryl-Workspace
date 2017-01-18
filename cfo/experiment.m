% CFO Experiment

% Create a periodic preamble
s = [ mod(1:16, 2), mod(1:16, 2) ] / sqrt(32);
v = 2 * (randn(1,32) + 1j*randn(1,32));
y = s .* exp(2j*pi*0.025*(0:31)) + v;
y1 = y;

estimates = zeros(2, 1);
for index = 1:10
    estimate = angle(conj(y1(1:16))*y1(17:end).')/(16*2*pi);
    y1 = y1 .* exp(-2j*pi*estimate*(0:31));
    estimates(index) = estimate;
end

figure()
plot(estimates); hold on;
plot(cumsum(estimates), 'r-.'); hold off;
