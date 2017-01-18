% decoder.m

[H, z] = ldpc80216;

[rows, cols] = size(H);

% Store sparse B matrix to compute B * p1
fid = fopen('matrix_H_rows.txt', 'w+');

for row = 1:rows
    first = 1;
    for col = 1:cols
        if H(row, col) ~= 0
            if first == 1
                fprintf(fid, '%d', col-1);
                first = 0;
            else
                fprintf(fid, ', %d', col-1);
            end
        end
    end
    if row ~= rows
        fprintf(fid, '\n');
    end
end

fclose(fid);

% Store sparse B matrix to compute B * p1
fid = fopen('matrix_H_cols.txt', 'w+');

for col = 1:cols
    first = 1;
    for row = 1:rows
        if H(row, col) ~= 0
            if first == 1
                fprintf(fid, '%d', col-1);
                first = 0;
            else
                fprintf(fid, ', %d', col-1);
            end
        end
    end
    if row ~= rows
        fprintf(fid, '\n');
    end
end

fclose(fid);