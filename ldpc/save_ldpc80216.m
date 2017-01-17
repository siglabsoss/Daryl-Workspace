% Generate and save 802.16 LDPC 2304 length 1/2 rate G & H matrices to file as CSV

function [] = save_ldpc80216(output_path)
    % Generate H matrix
    [H, z] = ldpc80216;
    
    % Generate G matrix. This was adopted from
    % https://github.com/simgunz/802.11n-ldpc/blob/v2.1/buildHG.m
    
    % n and R are hardcoded for now to match the codeword length and rate
    % that the ldpc80216 function uses.

    n = 2304;
    R = 1/2;
    
    gfH = gf(H);
    k = n*R;
    B = gfH(:,1:n-k);
    C = gfH(:,n-k+1:n);
    C1 = inv(C);            % Very slow operation
    G = [eye(k);C1*B];

    CHECK = gfH*G;
    if any(CHECK(:))
        disp('G is not correct');
        return
    end
    
    G = double(G.x); % Convert from GF type to double
    G = G'; % Swapping rows/cols to match CSIM convention
    
    % Write matrices to file
    H_path = strcat(output_path, '/80216_H_2304_12.csv');
    G_path = strcat(output_path, '/80216_G_2304_12.csv');
    dlmwrite(H_path, H, 'delimiter', ',');
    dlmwrite(G_path, G, 'delimiter', ',');
    
end
