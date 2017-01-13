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

input_vector0 = reshape(double(q ~= 0), 16, 8).' * 2.^((0:15)')
output_vector0 = reshape(double(p ~= 0), 16, 8).' * 2.^((0:15)')

% Generate the test vectors for the, requires that generate_matrices.m be
% executed in the workspace first.

[OUTBITS, INBITS] = size(A);
INSIZE = 8;
OUTSIZE = 32;

x = zeros(INBITS, 1);
x(1:21:end) = 1;
x(1:21:end) = 1;
x = gf(x);
y = A * x;

input_vector1 = reshape(double(x ~= 0), INSIZE, INBITS/INSIZE).' * 2.^((0:(INSIZE-1))')
output_vector1 = reshape(double(y ~= 0), OUTSIZE, OUTBITS/OUTSIZE).' * 2.^((0:(OUTSIZE-1))')

fprintf('input_samples = {\n    ');
for inp = input_vector1(1:end)
    fprintf('%d, ', inp);
end
fprintf('\n};\n\n');

fprintf('output_samples_low = {\n');
for outp = output_vector1(1:3:end)
    fprintf('    %d,\n', outp);
end
fprintf('};\n\n');

fprintf('output_samples_mid = {\n');
for outp = output_vector1(2:3:end)
    fprintf('    %d,\n', outp);
end
fprintf('};\n\n');

fprintf('output_samples_high = {\n');
for outp = output_vector1(3:3:end)
    fprintf('    %d,\n', outp);
end
fprintf('};\n\n');

% Generate the test vectors for matrix E multiplication

[OUTBITS, INBITS] = size(E);
INSIZE = 32;
OUTSIZE = 32;

x = zeros(INBITS, 1);
x(1:21:end) = 1;
x(1:21:end) = 1;
x = gf(x);
y = E * x;

input_vector2 = reshape(double(x ~= 0), INSIZE, INBITS/INSIZE).' * 2.^((0:(INSIZE-1))')
output_vector2 = reshape(double(y ~= 0), OUTSIZE, OUTBITS/OUTSIZE).' * 2.^((0:(OUTSIZE-1))')

fprintf('input_samples_low = {\n');
for inp = input_vector2(1:3:end)
    fprintf('    %d,\n', inp);
end
fprintf('};\n\n');

fprintf('input_samples_mid = {\n');
for inp = input_vector2(2:3:end)
    fprintf('    %d,\n', inp);
end
fprintf('};\n\n');

fprintf('input_samples_high = {\n');
for inp = input_vector2(3:3:end)
    fprintf('    %d,\n', inp);
end
fprintf('};\n\n');

fprintf('output_samples_low = {\n');
for outp = output_vector2(1:3:end)
    fprintf('    %d,\n', outp);
end
fprintf('};\n\n');

fprintf('output_samples_mid = {\n');
for outp = output_vector2(2:3:end)
    fprintf('    %d,\n', outp);
end
fprintf('};\n\n');

fprintf('output_samples_high = {\n');
for outp = output_vector2(3:3:end)
    fprintf('    %d,\n', outp);
end
fprintf('};\n\n');

% Generate the test vectors for matrix B multiplication

[OUTBITS, INBITS] = size(B);
INSIZE = 32;
OUTSIZE = 32;

x = zeros(INBITS, 1);
x(96) = 1;
x = gf(x);
y = B * x;

input_vector3 = reshape(double(x ~= 0), INSIZE, INBITS/INSIZE).' * 2.^((0:(INSIZE-1))')
output_vector3 = reshape(double(y ~= 0), OUTSIZE, OUTBITS/OUTSIZE).' * 2.^((0:(OUTSIZE-1))')

fprintf('input_samples_low = {\n');
for inp = input_vector3(1:3:end)
    fprintf('    %d,\n', inp);
end
fprintf('};\n\n');

fprintf('input_samples_mid = {\n');
for inp = input_vector3(2:3:end)
    fprintf('    %d,\n', inp);
end
fprintf('};\n\n');

fprintf('input_samples_high = {\n');
for inp = input_vector3(3:3:end)
    fprintf('    %d,\n', inp);
end
fprintf('};\n\n');

fprintf('output_samples_low = {\n    ');
for outp = output_vector3(1:3:end)
    fprintf('%d, ', outp);
end
fprintf('\n};\n\n');

fprintf('output_samples_mid = {\n    ');
for outp = output_vector3(2:3:end)
    fprintf('%d, ', outp);
end
fprintf('\n};\n\n');

fprintf('output_samples_high = {\n    ');
for outp = output_vector3(3:3:end)
    fprintf('%d, ', outp);
end
fprintf('\n};\n\n');

% Generate the test vectors for matrix C multiplication

[OUTBITS, INBITS] = size(C);
INSIZE = 8;
OUTSIZE = 32;

x = zeros(INBITS, 1);
x(1:2:end) = 1;
x(1:13:end) = 1;
x(1:111:end) = 1;
x(1:201:end) = 1;
x(1:211:end) = 1;
x = gf(x);
y = C * x;

input_vector4 = reshape(double(x ~= 0), INSIZE, INBITS/INSIZE).' * 2.^((0:(INSIZE-1))')
output_vector4 = reshape(double(y ~= 0), OUTSIZE, OUTBITS/OUTSIZE).' * 2.^((0:(OUTSIZE-1))')

fprintf('input_samples = {\n    ');
for inp = input_vector4(1:end)
    fprintf('%d, ', inp);
end
fprintf('\n};\n\n');

fprintf('output_samples_low = {\n    ');
for outp = output_vector4(1:3:end)
    fprintf('%d, ', outp);
end
fprintf('\n};\n\n');

fprintf('output_samples_mid = {\n    ');
for outp = output_vector4(2:3:end)
    fprintf('%d, ', outp);
end
fprintf('\n};\n\n');

fprintf('output_samples_high = {\n    ');
for outp = output_vector4(3:3:end)
    fprintf('%d, ', outp);
end
fprintf('\n};\n\n');