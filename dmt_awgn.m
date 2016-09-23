% DMT Simulation
% AWGN channel
%
% This is an example of DMT modulation. The cyclic prefix is 
%

%% Parameters

% Number of Symbol Periods for Filter Design
K = 6;
% Oversampling Factor/FFT Size
L = 256;
% Noise Std. Dev.
sigma = 0.1;
% Cyclic Prefix Length
Ncp = 20;
% Number of Active Subcarriers (Centered at DC)
Na = 64;
% Number of symbols to transmit
Ns = 1000;

%% Generate symbol sequence
active = zeros(L, 1);
if mod(Na, 2) == 1
    active(1:(Na-1)/2)
    active(L-(Na-1)/2:L) = 1.0;
else
    active(1:Na/2) = 1.0;
    active(L-Na/2+1:L) = 1.0;
end

s = zeros(Ns*L, 1);
stemp = zeros(L, 1);
for index = 1:Ns
    stemp(active > 0) = sign(randn(Na, 1));
    s(1+(index-1)*L:index*L) = stemp;
end

%% IFFT + CP
x = zeros(L*Ns, 1);
for index = 1:Ns
    S = sqrt(L) * ifft(s((index - 1)*L + 1:index*L));
    x((index - 1)*(L + Ncp) + Ncp + 1:index*(L + Ncp)) = S;
    x((index - 1)*(L + Ncp) + 1:(index - 1)*(L + Ncp) + Ncp) = S(L-Ncp+1:L);
end

%% Channel Model
v = sigma * (randn(size(x)) + 1j*randn(size(x))) / sqrt(2);
y = x + v;

% figure()
% plot(real(x)); hold on;
% plot(imag(x), 'r'); hold off;
% figure()
% plot(real(y)); hold on;
% plot(imag(y), 'r'); hold off;

%% FFT + CP Removal (RX)
z = zeros(Ns, L);
for index = 1:Ns
    Xz = fft(y((index - 1)*(L + Ncp) + Ncp + 1:index*(L + Ncp))) / sqrt(L);
    z(index, :) = Xz;
end

figure()
plot(real(z(K:end,1))); hold on;
plot(imag(z(K:end,1)), 'r'); hold off;

figure()
plot(real(z(K:end,2)), imag(z(K:end,2)), '.');
xlim([-1.5, 1.5])
ylim([-1.5, 1.5])

figure()
[Y, freq] = pmtm(y);
plot((freq - pi) / (2*pi), 20*log10(abs(fftshift(Y))))
