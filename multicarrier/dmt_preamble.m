% DMT Simulation
% AWGN channel
% Time/Frequency Spreading in the Preamble
%

%% Parameters

% FFT Size
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
    active(1:(Na-1)/2) = 1.0;
    active(L-(Na-1)/2:L) = 1.0;
else
    active(1:Na/2) = 1.0;
    active(L-Na/2+1:L) = 1.0;
end

% Generate PN code across subcarriers
pn = sign(randn(Na, 1)); 
coded_sc = zeros(L, 1);
coded_sc(active ~= 0) = pn;

% Generate PN code in time
s = sign(randn(Ns, 1));

%% IFFT + CP
Nx = (L + Ncp) * Ns;
x = zeros(Nx, 1);
for index = 1:Ns
    S = sqrt(L) * s(index) * ifft(coded_sc);
    x((index - 1)*(L + Ncp) + Ncp + 1:index*(L + Ncp)) = S;
    x((index - 1)*(L + Ncp) + 1:(index - 1)*(L + Ncp) + Ncp) = S(L-Ncp+1:L);
end

%% Channel Model
h = [ 1 0 0 0 ]; % Impulse (No) Channel Model
y = conv(x, h);
v = sigma * (randn(size(y)) + 1j*randn(size(y))) / sqrt(2);
y = y + v;

% figure()
% plot(real(x)); hold on;
% plot(imag(x), 'r'); hold off;
% figure()
% plot(real(y)); hold on;
% plot(imag(y), 'r'); hold off;

y_buf = zeros(L + Ncp - 1, 1);
y_acorr = zeros(Nx, 1);
y_acorr_accum = 0.0;
y_acorr_avg_buf = zeros(L + Ncp - 1, 1);
y_acorr_avg_output = zeros(Nx, 1);
for index = 1:Nx
    y_acorr(index) = y(index) * conj(y_buf(end));
    y_buf(2:end) = y_buf(1:end-1);
    y_buf(1) = y(index);
    y_acorr_accum = y_acorr_accum + y_acorr(index) - y_acorr_avg_buf(end);
    y_acorr_avg_buf(2:end) = y_acorr_avg_buf(1:end-1);
    y_acorr_avg_buf(1) = y_acorr(index);
    y_acorr_avg_output(index) = y_acorr_accum;
end

% Plot Raw Autocorrelation output samples
% figure()
% plot(real(y_acorr)); hold on;
% plot(imag(y_acorr), 'r'); hold off;

% Plot averaged autocorrelation samples
figure()
plot(real(y_acorr_avg_output)); hold on;
plot(imag(y_acorr_avg_output), 'r'); hold off;

