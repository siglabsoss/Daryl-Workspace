

Ncp = 100;
Nfft = 1024;
Na = 1020;
Ns = 109;
sigma_n = 0.1;

a = rand(Na, 1);
pilot = zeros(Nfft, 1);

if mod(Na, 2) == 0
    kcnt = 1
    for k = -Na/2:Na/2-1
        pilot = pilot + exp(2j*pi*(a(kcnt)+k*(0:Nfft-1).'/Nfft));
        kcnt = kcnt + 1;
    end
else
    if Na > 1
        for k = -(Na-1)/2:Na/2-1
            pilot = pilot + exp(2j*pi*(a(kcnt)+k*(0:Nfft-1).'/Nfft));
        end
    else
        pilot = exp(2j*pi*(a(1)+(0:Nfft-1).'/Nfft));
    end
end
pilot = pilot / sqrt(Na);

if mod(Ns, 2) == 0
    s = exp(j*pi*257*(0:Ns-1).^2/Ns).' / sqrt(Ns);
else
    s = exp(j*pi*257*(0:Ns-1).*(1:Ns)/Ns).' / sqrt(Ns);
end

x = zeros((Nfft + Ncp) * Ns, 1);

for ns = 1:Ns
    x((ns-1)*(Nfft+Ncp)+Ncp+1:ns*(Nfft+Ncp)) = s(ns) * pilot;
    x((ns-1)*(Nfft+Ncp)+1:(ns-1)*(Nfft+Ncp)+Ncp) = s(ns) * pilot(Nfft-Ncp+1:Nfft);
end

figure();
plot(real(x)); hold on;
plot(imag(x), 'r'); hold off;

figure()
Css = xcorr([s;s;s], s);
plot(abs(Css));

channel = [1 0 0 0];
Kn = length(x) + length(channel) - 1;
noise = sigma_n * (randn(Kn, 1) + randn(Kn, 1)) / sqrt(2.0);

y = conv(x, channel) + noise;

% Matched Filter (for frequency domain despreading)
z = conv(y, conj(pilot(end:-1:1)));

% Matched Filter (for time domain despreading)
s_up = zeros(Ns * (Nfft + Ncp), 1);
s_up(1:Nfft+Ncp:end) = s;
p = conv(z, conj(s_up(end:-1:1)));

figure()
plot(real(z)); hold on;
plot(imag(z)); hold off;

figure()
plot(real(p)); hold on;
plot(imag(p)); hold off;
