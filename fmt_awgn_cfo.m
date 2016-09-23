% FMT Simulation
% AWGN channel + Carrier Frequency Offset
%
% This is an example of FMT modulation. The prototype filters have a 
% roll-off of 1.0 for simplicity. This allows the filter bank to be
% critically sampled. Various parameters are provided below.
%

%% Parameters

% Number of Symbol Periods for Filter Design
K = 6;
% Oversampling Factor/FFT Size
L = 256;
% Noise Std. Dev.
sigma = 0.1;
% Number of Active Subcarriers (Centered at DC)
Na = 64;
% Number of symbols to transmit
Ns = 1000;
% Frequency offset normalized to the subcarrier spacing (1 / L)
delta_f = 0.1;

%% Prototype Filter Design
h = sr_Nyquist_p(K*L, L, 1.0, 1.0);

%% Generate symbol sequence
active = zeros(L, 1);
if mod(Na, 2) == 1
    active(2:2:Na) = 1.0;
    active(L-Na+1:2:L) = 1.0;
else
    active(1:2:Na) = 1.0;
    active(L-Na+1:2:L) = 1.0;
end

s = zeros(Ns*L, 1);
stemp = zeros(L, 1);
for index = 1:Ns
    stemp(active > 0) = sign(randn(Na, 1));
    s(1+(index-1)*L:index*L) = stemp;
end

%% Synthesis Filter Bank (TX)
x = synthesis_fb(s, h, L);

%% Channel Model
v = sigma * (randn(size(x)) + 1j*randn(size(x))) / sqrt(2);
y = x .* exp(2j*pi*delta_f/L*(0:length(x)-1).') + v;

% figure()
% plot(real(x)); hold on;
% plot(imag(x), 'r'); hold off;
% figure()
% plot(real(y)); hold on;
% plot(imag(y), 'r'); hold off;

%% Analysis Filter Bank (RX)
h2 = [ zeros(L-1, 1); h ];
z = analysis_fb(y, h2, L);

demod = repmat(exp(-2j*pi*delta_f*(0:Ns-1).'), 1, L);
z = z .* demod;

% Remove residual phase offset (should be 2 * pi * delta_f * K * sc_index
% or 2 * pi * delta_f * (K + 1) * k, depending whether padding was needed).
% We just estimate it to avoid ambiguity, this should cause a penalty at
% very low SNRs.
demod = repmat(exp(-1j*angle(mean(z.*z))/2), Ns, 1);
z = z .* demod;

figure()
plot(real(z(K:end,1))); hold on;
plot(imag(z(K:end,1)), 'r'); hold off;

figure()
plot(real(z(K:end,1)), imag(z(K:end,1)), '.');
hold on;
plot(real(z(K:end,63)), imag(z(K:end,63)), 'r.');
hold off;
xlim([-1.5, 1.5])
ylim([-1.5, 1.5])

figure()
[Y, freq] = pmtm(y);
plot((freq - pi) / (2*pi), 20*log10(abs(fftshift(Y))))
