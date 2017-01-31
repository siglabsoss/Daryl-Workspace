% DMT Simulation
% AWGN channel + Carrier Frequency Offset
%
% Shows an example of the autocorrellation + matched filter approach to
% timing offset estimation.
%

%% Parameters

% Number of Symbol Periods for Filter Design
K = 6;
% Oversampling Factor/FFT Size
L = 1024;
% Noise Std. Dev.
sigma = 0.0;
% Cyclic Prefix Length
Ncp = 20;
% Number of Active Subcarriers (Centered at DC)
Na = 40;
% Number of symbols to transmit
Ns = 5000;
% Frequency offset normalized to the subcarrier spacing (1 / L)
delta_f = 0.5;
% Number of FFT symbols in the comb filter
Ncomb = 500;
% Number of FFT symbols prior to the preamble
Npre = 1000;

%% Generate symbol sequence
active = zeros(L, 1);
pre_active = zeros(L, 1);
if mod(Na, 2) == 1
    active(1:(Na-1)/2) = 1.0;
    active(L-(Na-1)/2:L) = 1.0;

    pre_active(1:(Na-1)/2) = 1.0;
    pre_active(L-(Na-1)/2:L) = 1.0;
else
    active(1:Na/2) = 1.0;
    active(L-Na/2+1:L) = 1.0;

    pre_active(1:Na/2) = 1.0;
    pre_active(L-Na/2+1:L) = 1.0;
end

% Zero out odd subcarriers
pre_active(2:2:end) = 0;
pre_active(1) = 0;

% Form differential encoded Zadoff-Chu Sequence
szc = exp(1j*pi*13*(0:Ncomb-2).^2/(Ncomb-1));
szc_diff = ones(Ncomb, 1);
for index = 2:Ncomb
    szc_diff(index) = szc_diff(index-1) / szc(index-1);
end
s = zeros(Ns*L, 1);
stemp = zeros(L, 1);
spre = zeros(L, 1);
spre(pre_active > 0) = sign(randn(Na/2-1, 1)) / sqrt(Na/2 - 1);
for index = 1:Ns
    if (index <= Npre)
        % Random symbols before preamble
        stemp(active > 0) = sign(randn(Na, 1)) / sqrt(Na);
        s(1+(index-1)*L:index*L) = stemp;
    else
        if (index > Npre + Ncomb)
            % Random symbols after preamble
            stemp(active > 0) = sign(randn(Na, 1)) / sqrt(Na);
            s(1+(index-1)*L:index*L) = stemp;
        else
            % preamble symbols
            s(1+(index-1)*L:index*L) = szc_diff(index-Npre) * spre;
        end
    end
end

% figure();
% plot(real(szc)); hold on;
% plot(imag(szc), 'r'); hold off;
% szc_hat = szc_diff(1:end-1) .* conj(szc_diff(2:end));
% figure();
% plot(real(szc_hat)); hold on;
% plot(imag(szc_hat), 'r'); hold off;

%% IFFT + CP
x = zeros(L*Ns, 1);
for index = 1:Ns
    S = sqrt(L) * ifft(s((index - 1)*L + 1:index*L));
    x((index - 1)*(L + Ncp) + Ncp + 1:index*(L + Ncp)) = S;
    x((index - 1)*(L + Ncp) + 1:(index - 1)*(L + Ncp) + Ncp) = S(L-Ncp+1:L);
end

%% Channel Model
v = sigma * (randn(size(x)) + 1j*randn(size(x))) / sqrt(2);
y = x .* exp(2j*pi*delta_f/L*(0:length(x)-1).') + v;

% figure()
% plot(real(x)); hold on;
% plot(imag(x), 'r'); hold off;
% figure()
% plot(real(y)); hold on;
% plot(imag(y), 'r'); hold off;

ac_lag = zeros(Ns*L, 1);
pow_out = zeros(Ns*L, 1);
ac_buffer = zeros(L/2-1, 1);
pow_buffer = zeros(L/2-1, 1);
y_buffer = zeros(L/2-1, 1);
accum = 0.0;
accum2 = 0.0;
for index = 1:L * Ns
    % Compute products
    prod = y(index) * conj(y_buffer(end-1));
    prod2 = real(y(index) * conj(y(index)));
    % Compute Moving Average Filters
    accum = accum + prod - ac_buffer(end);
    accum2 = accum2 + prod2 - pow_buffer(end);
    % Rotate delay lines
    ac_buffer = [ prod; ac_buffer(1:end-1) ];
    pow_buffer = [ prod2; pow_buffer(1:end-1) ];
    y_buffer = [ y(index); y_buffer(1:end-1) ];
    % Write outputs
    ac_lag(index) = accum;
    pow_out(index) = accum2;
end

% figure()
% plot(abs(ac_lag).^2.0)

comb_seq = zeros((Ncomb-1)*(L+Ncp),1);
% comb_seq(1:L+Ncp:end) = 1.0;
comb_seq(1:L+Ncp:end) = szc(end:-1:1);

cf_seq = conv(ac_lag, comb_seq);
% cf2_seq = conv(ac_lag, conj(comb_seq));

figure()
% plot(abs(cf_seq) - abs(cf2_seq))
plot(abs(cf_seq))
hold on;
plot(pow_out, 'r')
hold off;

% %% FFT + CP Removal (RX)
% z = zeros(Ns, L);
% for index = 1:Ns
%     Xz = fft(y((index - 1)*(L + Ncp) + Ncp + 1:index*(L + Ncp))) / sqrt(L);
%     z(index, :) = Xz;
% end
%
% demod = repmat(exp(-2j*pi*delta_f*(L + Ncp)/L*(0:Ns-1).'), 1, L);
% z = z .* demod;
% figure()
% plot(real(demod(:,1))); hold on;
% plot(imag(demod(:,1)), 'r')
%
% figure()
% plot(real(z(K:end,1))); hold on;
% plot(imag(z(K:end,1)), 'r'); hold off;
%
% figure()
% plot(real(z(K:end,2)), imag(z(K:end,2)), '.');
% xlim([-1.5, 1.5])
% ylim([-1.5, 1.5])
%
% figure()
% [Y, freq] = pmtm(y);
% plot((freq - pi) / (2*pi), 20*log10(abs(fftshift(Y))))
