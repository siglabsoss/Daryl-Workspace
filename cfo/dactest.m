h = dlmread('fir0.txt');

figure()
plot(h)

H = fftshift(fft(h, 2^18));
f = (-2^17:2^17-1)*2^-18;

figure()
plot(250*f, 20*log10(abs(H))); hold on;

G1 = double(abs(125*f) > 22.5);
G2 = double(abs(125*f) < 47.5);
Gprime = max(20*log10(abs(H))) * G1 .* G2 + 1e-12;

f2 = [f - 1 - 2^-18, f, f + 1];
G = [Gprime, Gprime, Gprime];

plot(125*f2, G); hold off;
xlim([-125, 125])
