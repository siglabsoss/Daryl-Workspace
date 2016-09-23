% SMT Simulation
% AWGN channel
%
% This is an example of SMT modulation. The prototype filters have a 
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

%% Prototype Filter Design
h = sr_Nyquist_p(K*L, L, 1.0, 1.0);

%% Generate symbol sequence
active_even = zeros(L, 1);
active_odd = zeros(L, 1);
if mod(Na, 2) == 1
    active_even(2:2:(Na-1)/2) = 1.0;
    active_even(L-(Na-1)/2+1:2:L) = 1.0;
    active_odd(1:2:(Na-1)/2) = 1.0;
    active_odd(L-(Na-1)/2:2:L) = 1.0;
else
    active_even(2:2:Na/2) = 1.0;
    active_even(L-Na/2+1:2:L) = 1.0;
    active_odd(1:2:Na/2) = 1.0;
    active_odd(L-Na/2+2:2:L) = 1.0;
end

Na_even = sum(active_even);
Na_odd = sum(active_odd);
s_even = zeros(Ns*L, 1);
s_odd = zeros(Ns*L, 1);
stemp = zeros(L, 1);
for index = 1:Ns
    stemp(active_even > 0) = sign(randn(Na_even, 1));
    s_even(1+(index-1)*L:index*L) = stemp;
    stemp(active_even > 0) = 0;
    
    stemp(active_odd > 0) = sign(randn(Na_odd, 1));
    s_odd(1+(index-1)*L:index*L) = stemp;
    stemp(active_odd > 0) = 0;
end

%% Synthesis Filter Bank (TX)
x_even = synthesis_fb(s_even, h, L);
x_odd = synthesis_fb(s_odd, h, L);
x = [ x_even; zeros(L/2, 1) ] + [ zeros(L/2, 1); x_odd ];

%% Channel Model
v = sigma * (randn(size(x)) + 1j*randn(size(x))) / sqrt(2);
y = x + v;

% figure()
% plot(real(x)); hold on;
% plot(imag(x), 'r'); hold off;
% figure()
% plot(real(y)); hold on;
% plot(imag(y), 'r'); hold off;

%% Analysis Filter Bank (RX)
h2 = [ zeros(L - 1, 1); h ];
z1 = analysis_fb(y, h2, L);
h3 = [ zeros(L - 1 + L / 2, 1); h ];
z2 = analysis_fb(y, h3, L);

figure()
plot(real(z1(K:end,1))); hold on;
plot(imag(z1(K:end,1)), 'r'); hold off;

figure()
subplot(2,1,1)
plot(real(z1(K:end,2)), imag(z1(K:end,2)), '.');
xlim([-1.5, 1.5])
ylim([-1.5, 1.5])
subplot(2,1,2)
plot(real(z2(K+1:end,3)), imag(z2(K+1:end,3)), 'm.');
xlim([-1.5, 1.5])
ylim([-1.5, 1.5])

figure()
[Y, freq] = pmtm(y);
plot((freq - pi) / (2*pi), 20*log10(abs(fftshift(Y))))
