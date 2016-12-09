
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
phi = E * (T \ B) + D;
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
        if row ~= m-g
            fprintf(fid, '\n');
        end
    end
end

fclose(fid);

% Store sparse E matrix to compute -E * (inv(T) * (A * s))
fid = fopen('matrix_E.txt', 'w+');

for row = 1:m-g
    first = 1;
    for col = 1:m-g
        if E(row, col) ~= 0
            if first == 1
                fprintf(fid, '%d', col);
                first = 0;
            else
                fprintf(fid, ', %d', col);
            end
        end
        if row ~= m-g
            fprintf(fid, '\n');
        end
    end
end

fclose(fid);

% Store sparse C matrix to compute C * s
fid = fopen('matrix_C.txt', 'w+');

for row = 1:g
    first = 1;
    for col = 1:n-m
        if C(row, col) ~= 0
            if first == 1
                fprintf(fid, '%d', col);
                first = 0;
            else
                fprintf(fid, ', %d', col);
            end
        end
        if row ~= g 
            fprintf(fid, '\n');
        end
    end
end

fclose(fid);

% Store dense inv(phi) matrix to Compute p1 = -inv(phi) * E * (inv(T) * (A * s))
% TODO: Use a dense matrix format here... Probably that will simplify things in
%       the hardware implementation.
fid = fopen('matrix_inv_phi.txt', 'w+');

for row = 1:g
    first = 1;
    for col = 1:g
        if inv_phi(row, col) ~= 0
            if first == 1
                fprintf(fid, '%d', col);
                first = 0;
            else
                fprintf(fid, ', %d', col);
            end
        end
        if col ~= g 
            fprintf(fid, '\n');
        end
    end
end

fclose(fid);

% Store sparse B matrix to compute B * p1
fid = fopen('matrix_B.txt', 'w+');

for row = 1:m-g
    first = 1;
    for col = 1:g
        if B(row, col) ~= 0
            if first == 1
                fprintf(fid, '%d', col);
                first = 0;
            else
                fprintf(fid, ', %d', col);
            end
        end
        if col ~= m-g
            fprintf(fid, '\n');
        end
    end
end

fclose(fid);
