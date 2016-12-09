
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

% Precompute dense phi matrix
phi = E * inv(T) * B + D;
inv_phi = inv(phi);

%% Store the results in matrix files

% Store sparse A matrix to compute A * s
fid = fopen('matrix_A.txt', 'w+');

for row = 1:m-g
    first = 1;
    for col = 1:n-m
        if A(row, col) ~= 0
            if first == 1
                fprintf(fid, '%d', col);
                first = 0;
            else
                fprintf(fid, ', %d', col);
            end
        end
        fprintf(fid, '\n');
    end
end

fclose(fid);
% Store sparse E matrix to compute -E * (inv(T) * (A * s))

% Store sparse C matrix to compute C * s

% Store dense inv(phi) matrix to Compute p1 = -inv(phi) * E * (inv(T) * (A * s))

% Store sparse B matrix to compute B * p1
