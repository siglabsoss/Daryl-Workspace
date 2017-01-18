% CFO Experiment

% Create a periodic preamble
s = [1:16, 1:16] / sqrt(32);
v = 2*randn(1,32) + 1j*randn(1,32);
y = s + v;
y1 = y;

estimates = zeros(10, 1);
for index = 1:10
    estimate = angle(conj(s4(1:16))*s4(17:end).')/(16*2*pi);
    y1 = y1 .* exp(-2j*pi*estimate*(0:31));
    estimates(index) estimate;
end

disp(estimate(1), sum(esimates))

figure()
plot(estimates)
