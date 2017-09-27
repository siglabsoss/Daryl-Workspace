M = 16;
N = 1024;

alpha = 0.5;

t = (-N/2:N/2-1).';

% h = rand(1024,1) - 0.5;
% h = h .* (1.0 - abs(-512:511)'./512);
h = (1/M) * sinc((1/M)*t);
h(1) = 0.0;
h = h / sum(h);

w = abs((1/M) * sinc((1/M)*t));

figure()
plot(h)
title('pulse before')

figure()
g = conv(h, h(end:-1:1));
plot(g); hold on;
[~, m0] = max(g);
m0 = rem(m0 - 1, M);
if m0 == -1
    m0 = M-1;
end
plot(m0+1:M:length(g), g(m0+1:M:end), 'o'); hold off;

for index = 1:10000
    fval = 0.0;
    gval = zeros(length(h),1);
    for m = 0:M:N-1
        [a,b] = comp(h, m0 + m);
        if (rem(index, 10) >= 0)
            if (abs(a) > abs(fval))
                fval = a;
                gval = b;
            end
        else
            fval = fval + a;
            gval = gval + b / N;
        end
    end
    gval = gval .* (1.0 - abs(-512:511)'./512);
    gval(2:512) = 0.5 * (gval(2:512) + gval(514:end));
    gval(514:end) = gval(2:512);
    gval(1) = 0.0;
    h = h - alpha * fval * gval;
    h = h ./ sum(h);
    % h(h~=0) = w .* (h(h~=0) ./ abs(h(h~=0)));
    % h = h / sqrt(h' * h);
end

figure()
plot(h)
title('pulse after')

figure()
g = conv(h, h(end:-1:1));
plot(g); hold on;
plot(1:M:length(g), g(1:M:end), 'o'); hold off;

