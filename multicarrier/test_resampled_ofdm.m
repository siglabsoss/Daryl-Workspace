% simple script to test resampled_ofdm

Ns = 40;

N = 1024;
Ncp = 100;
T = N * (1.0 / N); % Fundamental frequency of 
Tcp = Ncp * (1.0 / N);
Ts = T/N; % Sampling period
% s = sign(randn(4*1024));
s = zeros(Ns*N, 1);
s(256:N:end) = (-1).^(0:Ns-1).';
t = 0.0:Ts:Ns*(T+Tcp);

x = resampled_ofdm(t, s, T, Tcp, N);

figure()
plot(real(x)); hold on;
plot(imag(x), 'r'); hold off;

% Simple decode
shat = zeros(Ns*N, 1);
for n = 1:Ns
    shat(N*n+1:N*n+N) = sqrt(N) * ifft(x((N+Ncp)*n+Ncp:(N+Ncp)*n+Ncp+N-1));
end

figure()
plot(real(x(256:N:end)), imag(x(256:N:end)), '.');

