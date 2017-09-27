% White noise test (simulation of hardware including DAC)


%% Generate white noise sequence using an LFSR
Q = 32;

N = min(2.^Q-1, 2.^16);
if Q == 3
    fb_taps = [Q, 2];
elseif Q == 4
    fb_taps = [Q, 3];
elseif Q == 5
    fb_taps = [Q, 3];
elseif Q == 6
    fb_taps = [Q, 5];
elseif Q == 7
    fb_taps = [Q, 6];
elseif Q == 8
    fb_taps = [Q, 6, 5, 4];
elseif Q == 9
    fb_taps = [Q, 5];
elseif Q == 10
    fb_taps = [Q, 7];
elseif Q == 11
    fb_taps = [Q, 9];
elseif Q == 12
    fb_taps = [Q, 6, 4, 1];
elseif Q == 13
    fb_taps = [Q, 4, 3, 1];
elseif Q == 14
    fb_taps = [Q, 5, 3, 1];
elseif Q == 15
    fb_taps = [Q, 14];
elseif Q == 16
    fb_taps = [Q, 15, 13, 4];
elseif Q == 17
    fb_taps = [Q, 14];
elseif Q == 18
    fb_taps = [Q, 11];
elseif Q == 32
    fb_taps = [Q, 22, 2, 1];
end

taps = ones(Q, 1);

% x = zeros(N, 1);
b = zeros(N, 1);

weights = 2.^(Q-1:-1:0).';
weights(1) = -weights(1);
weights = flipud(weights);

for idx = 1:N
    % Xor all taps for feedback path
    fb = taps(fb_taps(1));
    for fb_tap = fb_taps(2:end)
        fb = xor(fb, taps(fb_tap));
    end
    taps(2:end) = taps(1:end-1);
    taps(1) = fb;
    % taps(1:end-1) = taps(2:end);
    % taps(end) = fb;
    % x(idx) = taps' * weights;
    b(idx) = 2 * double(fb) - 1;
end

%% Filtering chain

% h0 coefficients
h0 = [
    -122.0
    0.0
    187.0
    0.0
    -323.0
    0.0
    517.0
    0.0
    -785.0
    0.0
    1146.0
    0.0
    -1622.0
    0.0
    2243.0
    0.0
    -3051.0
    0.0
    4112.0
    0.0
    -5533.0
    0.0
    7520.0
    0.0
    -10511.0
    0.0
    15656.0
    0.0
    -27184.0
    0.0
    83231.0
    131072.0
    83231.0
    0.0
    -27184.0
    0.0
    15656.0
    0.0
    -10511.0
    0.0
    7520.0
    0.0
    -5533.0
    0.0
    4112.0
    0.0
    -3051.0
    0.0
    2243.0
    0.0
    -1622.0
    0.0
    1146.0
    0.0
    -785.0
    0.0
    517.0
    0.0
    -323.0
    0.0
    187.0
    0.0
    -122.0
];

% fir0 coefficients

fir0 = [ 
    6
    0
    -19
    0
    47
    0
    -100
    0
    192
    0
    -342
    0
    572
    0
    -914
    0
    1409
    0
    -2119
    0
    3152
    0
    -4729
    0
    7420
    0
    -13334
    0
    41527
    65536
    41527
    0
    -13334
    0
    7420
    0
    -4729
    0
    3152
    0
    -2119
    0
    1409
    0
    -914
    0
    572
    0
    -342
    0
    192
    0
    -100
    0
    47
    0
    -19
    0
    6
];

% fir0 = [1, 1];

y1up = zeros(2*length(b),1);
y1up(1:2:end) = b;
y1 = conv(y1up, h0);

y2up = zeros(2*length(y1),1);
y2up(1:2:end) = y1;
y2 = conv(y2up, h0);

% y2m = y2 .* cos(-2*pi*35/125*(0:(length(y2)-1)).');
y2m = y2 .* exp(-2j*pi*35/125*(0:(length(y2)-1)).');
y2m = real(y2m);

y3up = zeros(2*length(y2m), 1);
y3up(1:2:end) = y2m;
y3 = conv(y3up, fir0);

[H, f] = freqz(y3/max(abs(y3)), 1, 2.^16, 250);
figure()
plot(f, 20*log10(abs(H)))
xlim([0, 250/2])
ylim([-130, -30] + 100)


