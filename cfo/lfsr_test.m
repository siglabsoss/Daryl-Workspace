% LFSR test

Q = 11;

N = 2.^Q-1;
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
end

taps = ones(Q,1);

x = zeros(N,1);
b = zeros(N,1);

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
    x(idx) = taps' * weights;
    b(idx) = 2 * double(fb) - 1;
end

% figure()
% plot(b)
% 
% figure()
% freqz(b)
% 
% figure()
% plot(x)
% 
% figure()
% freqz(x)

figure()
plot(conv(b, flipud([b;b;b])))

figure()
plot(conv(x, flipud([x;x;x])))