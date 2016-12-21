clear all;
Nfft = 1024;
Ncp = Nfft/8;
Na = 1;
Ns = 511;% needs to be a prime number wrt u for the Zadoff-Chu sequence
u=13; %root of Zadoff-Chu sequence
sigma_n = 0.1;
a = rand(Na, 1);
distance=1500; %distance between the two nodes
tx_BW=25e6*Na/Nfft;
tx_P_mw=1000; %1000 mw transmit power
tx_P=10*log10(tx_P_mw/tx_BW);%in dBm/Hz
active = zeros(Nfft, 1);
% if mod(Na, 2) == 1
%     active(1:L/Na:L/2) = 1.0;
%     active(L-(Na-1)/2:L) = 1.0;
% else
    active(1:(Nfft/Na):Nfft/2) = 1.0;
    active(Nfft/2+2:(Nfft/Na):Nfft) = 1.0;
pn=PNgen(1024);
% Generate PN code across subcarriers
%pn(1:12)=[1+j,-1-j,1+j,-1-j,-1-j,1+j,-1-j,-1-j,1+j,1+j,1+j,1+j]';
pilot= zeros(Nfft, 1);
%pilot(active ~= 0) = pn(1:Na)/sqrt(Na);s = pn(Na+1:Na+Ns);
pilot(active ~= 0) = rand(Na,1)/sqrt(Na);s = lteZadoffChuSeq(u,Ns);
pilot=ifft(pilot,Nfft);
x = zeros((Nfft + Ncp) * Ns, 1);
for ns = 1:Ns
    x((ns-1)*(Nfft+Ncp)+Ncp+1:ns*(Nfft+Ncp)) = s(ns) * pilot;
    x((ns-1)*(Nfft+Ncp)+1:(ns-1)*(Nfft+Ncp)+Ncp) = s(ns) * pilot(Nfft-Ncp+1:Nfft);
end
figure();
plot(real(x)); hold on;
plot(imag(x), 'r'); hold off;
%temp=IEEE80216channel(distance);
%channel=1./temp;
channel(:,1)=2.7439e-11 + 8.5456e-11i;% channel for 15Km
%channel(:,1)=3.7482e-08 - 1.9397e-09i;% channel for 1.5km
x=x*channel(:,1);
y=awgn(x,tx_P+(20*log10(abs(channel(:,1))))+170,'measured');
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
figure;
plot(abs(p));
figure;
plot(abs(xcorr([y;y;y],x)));

