% ldpc_test_vectors.m

% Generate the dual diagonal matrix
X = eye(16*8, 16*8); 
X(9:end, 1:end-8) = X(9:end, 1:end-8) + eye(15*8, 15*8);

% Input and output vectors.
p = zeros(16*8, 1);
p(1:3:end) = 1;
q = mod(X * p, 2);

input_vector = (reshape(q, 16, 8).') * 2.^((0:15)')
output_vector = (reshape(p, 16, 8).') * 2.^((0:15)')