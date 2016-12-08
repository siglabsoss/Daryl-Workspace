ldpc80216

% Derive encoder parameters from variables in ldpc80216 script
g = z;
[m, n] = size(H);

% Create the submatrices
A = H(1:m-g, 1:n-m);
B = H(1:m-g, n-m+1:n-m+g);
T = H(1:m-g, n-m+g+1:n);
C = H(m-g+1:m, 1:n-m);
D = H(m-g+1:m, n-m+1:n-m+g);
E = H(m-g+1:m, n-m+g+1:n);

% figure()
% spy(A)
% figure()
% spy(B)
% figure()
% spy(T)
% figure()
% spy(C)
% figure()
% spy(D)
% figure()
% spy(E)


