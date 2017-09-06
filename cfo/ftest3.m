% 


x = cos(2*pi*0.001*(0:1000).');
% x = cos(2*pi*0.001*(0:1000).'-pi/10);
M = 10;

h1 = firpm(40, 2*[0.0, 0.025, 0.075, 0.5], [ 10.0, 10.0, 0.0, 0.0 ] ).';
h1 = conv(h1, ones(M,1)/M);
h1 = conv(h1, ones(M,1)/M);

figure()
plot(h1)

xup1 = zeros(M * length(x), 1);
xup1(1:M:end) = x;

xup2 = zeros(M * length(x), 1);
for index = 1:M
    xup2(index:M:end) = x / M;
end

y1 = conv(xup1, h1);
y2 = conv(xup2, h1);

figure()
plot(1:length(y1), y1); hold on;
plot((1:length(y2))-M/2, y2); hold off;

% figure(10)
% freqz(h1)
% figure(11)
% freqz(xup1)
% figure(12)
% freqz(xup2)
figure(13)
freqz(y1)
figure(14)
freqz(y2)
