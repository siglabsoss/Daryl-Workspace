
%% Execute LDPC script to generate code and parameters
ldpc80216

%% Generate submatrices and derive parameters from script output

% Derive encoder parameters from variables in ldpc80216 script
g = z;
[m, n] = size(H);

% Create the submatrices
A = gf(H(1:m-g, 1:n-m));
B = gf(H(1:m-g, n-m+1:n-m+g));
T = gf(H(1:m-g, n-m+g+1:n));
C = gf(H(m-g+1:m, 1:n-m));
D = gf(H(m-g+1:m, n-m+1:n-m+g));
E = gf(H(m-g+1:m, n-m+g+1:n));

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

% Precompute dense phi matrix
phi = E * inv(T) * B + D;

% Create the information bit sequence (systematic part)
s = gf(zeros(n - m, 1));
s(1:5:end) = 1;

% Preserve room for the two parity sections
p1 = gf(zeros(g, 1));
p2 = gf(zeros(m - g, 1));

%% Compute p1 (first section of parity bits)

% Compute a = A * s
% TODO: Replace matrix multiply by sparse matrix multiply
a = A * s;

% Use back substitution to compute b = inv(T) * (A * s)
% TODO: Replace inv(T) with back substitution
b = inv(T) * (A * s);
% b = gf(zeros(m - g, 1));
% for index = 2:(n - m)/g
%     b((index-1)*g+1:index*g) = a((index-1)*g+1:index*g) + a((index-2)*g+1:(index-1)*g);
% end

% Compute c = -E * (inv(T) * (A * s))
% TODO: Replace matrix multiply by sparse matrix multiply
c = E * b;

% Compute d = C * s
% TODO: Replace matrix multiply by sparse matrix multiply
d = C * s;

% Compute e = (-E * (inv(T) * (A * s))) + (C * s)
e = c + d;

% Compute p1 using a dense matrix multiply
p1(:) = inv(phi) * e;

%% Compute p2 (second section of parity bits)
% Compute q = B * p1
% TODO: Replace matrix multiply by sparse matrix multiply
q = B * p1;

% Compute (A * s) + (B * p1)
r = a + q;

% Compute p2
% TODO: Replace inv(T) with back substitution
p2(:) = inv(T) * r;

% Concatenate to yield codeword
c = [ s ; p1; p2 ];
