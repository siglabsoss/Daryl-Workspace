X = randn(1,1024) + 1j*randn(1,1024);

% TD decimation
x = ifft(X)
x_td_dec = x(1:4:1024);

% FD decimation
X_aliased = X(1:256) + X(257:512) + X(513:768) + X(769:1024);
x_fd_dec = ifft(X_aliased)/4;

figure();
plot(real(x), 'b'); hold on;
plot(imag(x), 'r'); hold on;
plot(1:4:length(x), real(x_td_dec), 'b.');
plot(1:4:length(x), imag(x_td_dec), 'r.');
plot(1:4:length(x), real(x_fd_dec), 'bo');
plot(1:4:length(x), imag(x_fd_dec), 'ro'); hold off;

figure();
plot(abs(x_td_dec - x_fd_dec))

