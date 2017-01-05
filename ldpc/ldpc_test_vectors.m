% ldpc_test_vectors.m

% Generate the dual diagonal matrix
X = eye(16*8, 16*8); 
X(1+16:end, 1:end-16) = X(16+1:end, 1:end-16) + eye(16*(8-1), 16*(8-1));
X = gf(X);

% Input and output vectors.
p = zeros(16*8, 1);
p(1:3:end) = 1;
p = gf(p);
q = X * p;

input_vector = reshape(double(q ~= 0), 16, 8).' * 2.^((0:15)')
output_vector = reshape(double(p ~= 0), 16, 8).' * 2.^((0:15)')
